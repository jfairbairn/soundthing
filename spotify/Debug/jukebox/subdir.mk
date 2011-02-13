################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../jukebox/alsa-audio.o \
../jukebox/appkey.o \
../jukebox/audio.o \
../jukebox/jukebox.o 

C_SRCS += \
../jukebox/alsa-audio.c \
../jukebox/audio.c \
../jukebox/dummy-audio.c \
../jukebox/jukebox.c \
../jukebox/openal-audio.c \
../jukebox/osx-audio.c \
../jukebox/playtrack.c 

OBJS += \
./jukebox/alsa-audio.o \
./jukebox/audio.o \
./jukebox/dummy-audio.o \
./jukebox/jukebox.o \
./jukebox/openal-audio.o \
./jukebox/osx-audio.o \
./jukebox/playtrack.o 

C_DEPS += \
./jukebox/alsa-audio.d \
./jukebox/audio.d \
./jukebox/dummy-audio.d \
./jukebox/jukebox.d \
./jukebox/openal-audio.d \
./jukebox/osx-audio.d \
./jukebox/playtrack.d 


# Each subdirectory must supply rules for building sources it contributes
jukebox/%.o: ../jukebox/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


