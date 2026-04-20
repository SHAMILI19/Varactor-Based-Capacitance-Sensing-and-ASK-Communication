Project Overview:
This project demonstrates a complete pipeline where capacitance values (e.g., from a varactor diode) are processed, converted into digital signals, and transmitted using ASK modulation. The system combines:

MATLAB → Data generation (48 capacitance channels)
Simulink → Communication system modeling (MUX, noise, demodulation)
LTspice → Analog circuit simulation (varactor behavior)
Arduino (PWM) → Hardware implementation of signal conversion.

### Hardware Implementation
Arduino used to generate PWM output
Input given via Serial (0–1023 values)
PWM mapped to 0–255 using map()
Output observed on pin 9
Represents capacitance variation as duty cycle
 Connections
PWM pin → output/load (or measurement point)
GND → common ground
Serial input from PC
 Working Principle:
Capacitance values are converted to digital data → mapped to PWM → transmitted/processed using ASK in Simulink.

### Simulink Model
Designed ASK-based communication system
Multiplexed 48 capacitance channels using MUX
Added noise and used relational operator for detection
Observed transmitted and received signals using Scope.

### LTspice Simulation
Simulated varactor diode behavior
Verified capacitance variation with voltage
Analyzed frequency response of the circuit
 Integration:
Simulated capacitance values → converted to digital → transmitted using ASK → validated using hardware PWM output.
