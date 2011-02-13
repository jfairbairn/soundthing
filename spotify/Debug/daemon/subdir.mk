################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../daemon/appkey.o \
../daemon/main.o 

CPP_SRCS += \
../daemon/main.cpp 

OBJS += \
./daemon/main.o 

CPP_DEPS += \
./daemon/main.d 


# Each subdirectory must supply rules for building sources it contributes
daemon/%.o: ../daemon/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


