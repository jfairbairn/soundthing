################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../spshell/appkey.o \
../spshell/browse.o \
../spshell/cmd.o \
../spshell/inbox.o \
../spshell/playlist.o \
../spshell/search.o \
../spshell/social.o \
../spshell/spshell.o \
../spshell/spshell_posix.o \
../spshell/star.o \
../spshell/toplist.o 

C_SRCS += \
../spshell/browse.c \
../spshell/cmd.c \
../spshell/inbox.c \
../spshell/playlist.c \
../spshell/search.c \
../spshell/social.c \
../spshell/spshell.c \
../spshell/spshell_posix.c \
../spshell/star.c \
../spshell/toplist.c 

OBJS += \
./spshell/browse.o \
./spshell/cmd.o \
./spshell/inbox.o \
./spshell/playlist.o \
./spshell/search.o \
./spshell/social.o \
./spshell/spshell.o \
./spshell/spshell_posix.o \
./spshell/star.o \
./spshell/toplist.o 

C_DEPS += \
./spshell/browse.d \
./spshell/cmd.d \
./spshell/inbox.d \
./spshell/playlist.d \
./spshell/search.d \
./spshell/social.d \
./spshell/spshell.d \
./spshell/spshell_posix.d \
./spshell/star.d \
./spshell/toplist.d 


# Each subdirectory must supply rules for building sources it contributes
spshell/%.o: ../spshell/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


