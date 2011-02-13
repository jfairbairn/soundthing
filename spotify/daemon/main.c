#include "daemon.h"

static pthread_mutex_t mutex;
static pthread_cond_t main_cond;
static pthread_cond_t cmd_cond;

static void logged_in(sp_session *session, sp_error error)
{
	pthread_cond_signal(&cmd_cond);
}

static void logged_out(sp_session *session) {}
static void log_message(sp_session *session, const char *data) {fprintf(stderr, "%s", data);}
static void metadata_updated(sp_session *session) {}

static int sp_events = 0;

static void notify_main_thread(sp_session *session)
{
	sp_events = 1;
	pthread_cond_signal(&main_cond);
}

typedef enum {
	GET_TRACKS,
	ADD_TRACKS,
	NOW_PLAYING
} command_type;

typedef struct {
	bool ready;
	char username[17];
	char password[17];
	command_type mode;
	sp_track *tracks[64];
	size_t track_count;
} command;

static void connection_error(sp_session *session, sp_error error)
{
	fprintf(stderr, "Connection to Spotify failed: %s\n",
	                sp_error_message(error));
}
//static sp_session_callbacks callbacks;
static sp_session_callbacks callbacks = {
	&logged_in,
	&logged_out,
	&metadata_updated,
	&connection_error,
	NULL,
	&notify_main_thread,
	NULL,
	NULL,
	&log_message
};

static sp_session_config config;
static sp_session *g_session;

static command cmd;

void *cmdloop()
{
	do {
		pthread_cond_wait(&cmd_cond, &mutex);
		char cmdbuf[2048];
		char *str = gets(cmdbuf);


		// username password cmd tracks

		char *cur = str;
		char *space = strchr(cur, ' ');
		strncpy(cmd.username, cur, space - cur);
		cur = ++space;
		space = strchr(cur, ' ');
		strncpy(cmd.password, cur, space - cur);

		cur = ++space;
		char modechar = *cur++;
		switch (modechar)
		{
		case 'g':
			cmd.mode = GET_TRACKS;
			break;
		case 'a':
			cmd.mode = ADD_TRACKS;
			break;
		case 'n':
			cmd.mode = NOW_PLAYING;
			break;
		}
		space = ++cur;
		cmd.track_count = 0;
		char buf[256];
		while (*cur)
		{
			if (*space == 0 || *space == ';')
			{
				if (space > cur);
				strncpy(buf, cur, space-cur);
				buf[space-cur] = 0;
				sp_track *track = sp_link_as_track(sp_link_create_from_string(buf));
				sp_track_add_ref(track);
				cmd.tracks[cmd.track_count] = 0;
				cmd.track_count++;
				if (space == 0) cur = 0;
				else cur=++space;
			}
			else
			{
				space++;
			}
		}
		cmd.ready = true;
		pthread_cond_signal(&main_cond);
	} while (true);
}

void toplistbrowse_complete(sp_toplistbrowse *toplist, void *userdata)
{
//	pthread_mutex_lock(&mutex);
	size_t count = sp_toplistbrowse_num_tracks(toplist);
	sp_toplistbrowse_add_ref(toplist);
	printf("[");
	size_t i;
	char buf[256];
	for (i = 0; i < count; ++i)
	{
		if (i != 0) printf(",");
		sp_track *track = sp_toplistbrowse_track(toplist, i);
		sp_track_add_ref(track);
		const char *alname = sp_album_name(sp_track_album(track));
		const char *trname = sp_track_name(track);
		const char *arname = sp_artist_name(sp_track_artist(track, 0));
		sp_link_as_string( sp_link_create_from_track(track,0), buf, 256);
		printf("[\"%s\",\"%s\",\"%s\",\"%s\"]", trname, arname, alname, buf);
		sp_track_release(track);
	}
	printf("]\n");
	fflush(stdout);
	sp_toplistbrowse_release(toplist);
	pthread_cond_signal(&cmd_cond);
	exit(0);
//	pthread_mutex_unlock(&mutex);
}

void get_tracks()
{
	sp_toplistbrowse_create(g_session, SP_TOPLIST_TYPE_TRACKS, SP_TOPLIST_REGION_USER, cmd.username, &toplistbrowse_complete, NULL);
}

void add_tracks()
{

}

void now_playing()
{
	sp_toplistbrowse_create(g_session, SP_TOPLIST_TYPE_TRACKS, SP_TOPLIST_REGION_USER, cmd.username, &toplistbrowse_complete, NULL);
}

int main(int argc, char **argv)
{
	extern const uint8_t g_appkey[];
	extern const size_t g_appkey_size;

	pthread_mutex_init(&mutex, NULL);
	pthread_cond_init(&main_cond, NULL);
	pthread_cond_init(&cmd_cond, NULL);

//	memset(&callbacks, 0, sizeof(callbacks));
//	callbacks.logged_in = &logged_in;
//	callbacks.notify_main_thread = &notify_main_thread;
//	callbacks.logged_out = &logged_out;
//	callbacks.log_message = &log_message;
//	callbacks.connection_error = &connection_error;
//	callbacks.metadata_updated = &metadata_updated;

	memset(&config, 0, sizeof(config));
	config.api_version = SPOTIFY_API_VERSION;
	config.application_key = g_appkey;
	config.application_key_size = g_appkey_size;
	config.cache_location = "/tmp/soundthing";
	config.callbacks = &callbacks;
	config.user_agent = "soundthing";
	config.settings_location = "/tmp/soundthing";

	int next_timeout = 0;

	sp_session *session=0;
	sp_session_create(&config, &session);
	g_session = session;

	static pthread_t id;

	if (id)
		return -1;

	pthread_create(&id, NULL, cmdloop, NULL);

	sp_session_login(session, "furbage", "Timbuktu");

	while (true)
	{
		while (!(sp_events || cmd.ready))
		{
			pthread_cond_wait(&main_cond, &mutex);
		}

//		pthread_mutex_lock(&mutex);
		// process spotify events
		do {
			sp_session_process_events(g_session, &next_timeout);
		} while (next_timeout == 0);
		sp_events = 0;

		// process command
		if (cmd.ready)
		{
			switch(cmd.mode)
			{
			case GET_TRACKS:
				get_tracks();
				break;
			case ADD_TRACKS:
				add_tracks();
				break;
			case NOW_PLAYING:
				now_playing();
				break;
			}
			cmd.ready = false;
		}
//		pthread_mutex_unlock(&mutex);

	}

	return 0;
}
