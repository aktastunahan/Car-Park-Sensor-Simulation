# Car Park Sensor Simulation using TM4C123G Board
* **Hardware**  
  1. NOKIA 5110 LCD Screen
  2. 1 Potentiometer
  3. 2 Buttons Placed on the TM4C123G Board
  4. HC-SR04 Ultrasonic Sensor
  5. Stepper Motor
* **Pin Configurations**
  - Motor Control Pins
    | ULN2003A	| Tiva Board | 
    | --------- | -----| 
    | IN1 | PB0 |
    | IN2 | PB1 |
    | IN3 | PB2 |
    | IN3 | PB3 |
    
  - Nokia5110 Pins
    |	Signal			|	Nokia 5110	|	Tiva Board  |
    |	-------------	|	---------	|	---------	|
    |	Reset         	|	RST (pin1)	|	PA7  |
    |	SSI0Fss       	|	CE (pin 2)	|	PA3   |
    |	Data/Command	|	DC (pin 3)	|	PA6   |
    |	SSI0Tx        	|	Din (pin 4)	|	PA5   |
    |	SSI0Clk       	|	Clk (pin 5)	|	PA2   |
    |	3.3V			|	Vcc (pin 6)	|	3.3V  |
    |	back light		|	BL (pin 7)	|	3.3V  |
    |	Ground        	|	Gnd (pin8)	|	ground   |
    
  - HC-SR04 Pins
    |	HC-SR04	|	Tiva Board  |
     |	-----	|	-----	|	
    | ECHO |  PC6   |
    | TRIG |  PF2   
  - Potentiometer<br />
    3.3V, PE3, GND
