/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_up_avalon_character_lcd.h"
#define leds (char *) 0x0002050
#define gpio_bus (char *) 0x0002000
#define gpio_23 (char *) 0x0002010
#define gpio_24 (char *) 0x0002030
#define gpio_25 (char *) 0x0002020
char  convert_chars(int) ;

int main()
{
  printf("Hello from Nios II!\n");

  alt_up_character_lcd_dev * char_lcd_dev;
  	// open the Character LCD port
  	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/character_lcd_0");
  	if ( char_lcd_dev == NULL)
  	alt_printf ("Error: could not open character LCD device\n");
  	else
  	alt_printf ("Opened character LCD device\n");
  	/* Initialize the character display */
  	alt_up_character_lcd_init (char_lcd_dev);
  	/* Write "Welcome to" in the first row */
  	alt_up_character_lcd_string(char_lcd_dev, "Scan A Qr Code");
  	/* Write "the DE2 board" in the second row */

  int i[30];
  int index = 0;
  int prev = 0;
  int stable = 0;
  while (!*gpio_24){}
  while(!*gpio_25){ // not done
	if(*gpio_24){ // if valid
		*leds = *gpio_bus;

		if( *gpio_bus == prev){
			stable ++;
		}
		else {
			stable = 0;
		}

		prev = *gpio_bus;

		if (stable > 45){
			stable = 0;
			i[index] = 0x7f & *gpio_bus;
			printf("%i\n", i[index]);
			index ++;
			*gpio_23 = 1;
		}

	}else{
		*gpio_23 = 0;
	}
  }
  printf("done: ");

  // convert the values
  	char second_row[30];
  	char saved[30];
  	int k;
  	int len = 0;
  	for ( k = 0; k < 30; k++){
  		second_row[k] = convert_chars (i[k]);
  		saved[k] = second_row[k];
  		if (second_row[k] == '\0'){
  			second_row[k] = ' ';
  			saved[k] = ' ';
  			len = k;
  			break;
  		}
  	}
  	printf(" Length: %i", len);
  	while(1){
		int loop = 0;
		for (k = 0; k < len; k ++){
			second_row[k] = saved[k];
		}
			while (loop < len){
			alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
			alt_up_character_lcd_string(char_lcd_dev, second_row);

			int sleep;
			for (sleep = 0; sleep < 10000; sleep ++){
				int i = 5003040 / sleep;
			}
			for (k = 0 ; k < len; k ++){
				second_row[k] = second_row[k+1];
			}
			alt_up_character_lcd_init (char_lcd_dev);
			  	/* Write "Welcome to" in the first row */
			  alt_up_character_lcd_string(char_lcd_dev, "Scan A Qr Code");
			  	/* Write "the DE2 board" in the second row */
			alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
			alt_up_character_lcd_string(char_lcd_dev, second_row);
			loop ++;
			}
  	}
  return 0;
}

/* Convert integers in charac[] into actual characters */
char convert_chars(int chars) {
	/* Returns char */
	if (chars == 32) {
		return ' ';
	} else if (chars == 33) {
		return '!';
	} else if (chars == 34) {
		return '"';
	} else if (chars == 35) {
		return '#';
	} else if (chars == 36) {
		return '$';
	} else if (chars == 37) {
		return '%';
	} else if (chars == 38) {
		return '&';
	} else if (chars == 39) {
		return '`';
	} else if (chars == 40) {
		return '(';
	} else if (chars == 41) {
		return ')';
	} else if (chars == 42) {
		return '*';
	} else if (chars == 43) {
		return '+';
	} else if (chars == 44) {
		return ',';
	} else if (chars == 45) {
		return '-';
	} else if (chars == 46) {
		return '.';
	} else if (chars == 47) {
		return '/';
	} else if (chars == 48) {
		return '0';
	} else if (chars == 49) {
		return '1';
	} else if (chars == 50) {
		return '2';
	} else if (chars == 51) {
		return '3';
	} else if (chars == 52) {
		return '4';
	} else if (chars == 53) {
		return '5';
	} else if (chars == 54) {
		return '6';
	} else if (chars == 55) {
		return '7';
	} else if (chars == 56) {
		return '8';
	} else if (chars == 57) {
		return '9';
	} else if (chars == 58) {
		return ':';
	} else if (chars == 59) {
		return ';';
	} else if (chars == 60) {
		return '<';
	} else if (chars == 61) {
		return '=';
	} else if (chars == 62) {
		return '>';
	} else if (chars == 63) {
		return '?';
	} else if (chars == 64) {
		return '@';
	} else if (chars == 65) {
		return 'A';
	} else if (chars == 66) {
		return 'B';
	} else if (chars == 67) {
		return 'C';
	} else if (chars == 68) {
		return 'D';
	} else if (chars == 69) {
		return 'E';
	} else if (chars == 70) {
		return 'F';
	} else if (chars == 71) {
		return 'G';
	} else if (chars == 72) {
		return 'H';
	} else if (chars == 73) {
		return 'I';
	} else if (chars == 74) {
		return 'J';
	} else if (chars == 75) {
		return 'K';
	} else if (chars == 76) {
		return 'L';
	} else if (chars == 77) {
		return 'M';
	} else if (chars == 78) {
		return 'N';
	} else if (chars == 79) {
		return 'O';
	} else if (chars == 80) {
		return 'P';
	} else if (chars == 81) {
		return 'Q';
	} else if (chars == 82) {
		return 'R';
	} else if (chars == 83) {
		return 'S';
	} else if (chars == 84) {
		return 'T';
	} else if (chars == 85) {
		return 'U';
	} else if (chars == 86) {
		return 'V';
	} else if (chars == 87) {
		return 'W';
	} else if (chars == 88) {
		return 'X';
	} else if (chars == 89) {
		return 'Y';
	} else if (chars == 90) {
		return 'Z';
	} else if (chars == 91) {
		return '[';
	} else if (chars == 92) {
		return ' ';
	} else if (chars == 93) {
		return ']';
	} else if (chars == 94) {
		return '^';
	} else if (chars == 95) {
		return '_';
	} else if (chars == 96) {
		return '`';
	} else if (chars == 97) {
		return 'a';
	} else if (chars == 98) {
		return 'b';
	} else if (chars == 99) {
		return 'c';
	} else if (chars == 100) {
		return 'd';
	} else if (chars == 101) {
		return 'e';
	} else if (chars == 102) {
		return 'f';
	} else if (chars == 103) {
		return 'g';
	} else if (chars == 104) {
		return 'h';
	} else if (chars == 105) {
		return 'i';
	} else if (chars == 106) {
		return 'j';
	} else if (chars == 107) {
		return 'k';
	} else if (chars == 108) {
		return 'l';
	} else if (chars == 109) {
		return 'm';
	} else if (chars == 110) {
		return 'n';
	} else if (chars == 111) {
		return 'o';
	} else if (chars == 112) {
		return 'p';
	} else if (chars == 113) {
		return 'q';
	} else if (chars == 114) {
		return 'r';
	} else if (chars == 115) {
		return 's';
	} else if (chars == 116) {
		return 't';
	} else if (chars == 117) {
		return 'u';
	} else if (chars == 118) {
		return 'v';
	} else if (chars == 119) {
		return 'w';
	} else if (chars == 120) {
		return 'x';
	} else if (chars == 121) {
		return 'y';
	} else if (chars == 122) {
		return 'z';
	} else if (chars == 123) {
		return '{';
	} else if (chars == 124) {
		return '|';
	} else if (chars == 125) {
		return '}';
	} else if (chars == 126) {
		return '~';
	}
	return '\0';
}
