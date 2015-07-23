
_start:

;program.c,16 :: 		void start()
;program.c,18 :: 		dht22=0;
	BCF         RB0_bit+0, 0 
;program.c,19 :: 		trisb0_bit=0; // rb0 output
	BCF         TRISB0_bit+0, 0 
;program.c,20 :: 		delay_ms(5);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_start0:
	DECFSZ      R13, 1, 0
	BRA         L_start0
	DECFSZ      R12, 1, 0
	BRA         L_start0
	NOP
;program.c,21 :: 		trisb0_bit=1;  // rb0 input
	BSF         TRISB0_bit+0, 0 
;program.c,22 :: 		dht22=1;
	BSF         RB0_bit+0, 0 
;program.c,23 :: 		INTCON2.INTEDG0=0; // interrupt with falling edge
	BCF         INTCON2+0, 6 
;program.c,24 :: 		INTCON.INT0IE=1;    // Enable interrupt
	BSF         INTCON+0, 4 
;program.c,25 :: 		}
	RETURN      0
; end of _start

_conv_data:

;program.c,27 :: 		void conv_data()
;program.c,29 :: 		unsigned int temp1=0;
	CLRF        conv_data_temp1_L0+0 
	CLRF        conv_data_temp1_L0+1 
;program.c,30 :: 		unsigned int temp2=0;
	CLRF        conv_data_temp2_L0+0 
	CLRF        conv_data_temp2_L0+1 
;program.c,33 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data1:
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conv_data36
	MOVLW       16
	SUBWF       R3, 0 
L__conv_data36:
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data2
;program.c,35 :: 		if(packet[j+2]>60&&packet[j+2]<80)   // one
	MOVLW       2
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       60
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data6
	MOVLW       2
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       80
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data6
L__conv_data34:
;program.c,37 :: 		temp1=temp1|(1<<(15-j));
	MOVF        R3, 0 
	SUBLW       15
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__conv_data37:
	BZ          L__conv_data38
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data37
L__conv_data38:
	MOVF        R0, 0 
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;program.c,38 :: 		}
	GOTO        L_conv_data7
L_conv_data6:
;program.c,39 :: 		else if(packet[j+2]>0&&packet[j+2]<40)    //zero
	MOVLW       2
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data10
	MOVLW       2
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       40
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data10
L__conv_data33:
;program.c,41 :: 		temp1=temp1|(0<<(15-j));
	MOVF        R3, 0 
	SUBLW       15
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	CLRF        R0 
	CLRF        R1 
	MOVF        R2, 0 
L__conv_data39:
	BZ          L__conv_data40
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data39
L__conv_data40:
	MOVF        R0, 0 
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;program.c,42 :: 		}
L_conv_data10:
L_conv_data7:
;program.c,33 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;program.c,43 :: 		}
	GOTO        L_conv_data1
L_conv_data2:
;program.c,45 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data11:
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conv_data41
	MOVLW       16
	SUBWF       R3, 0 
L__conv_data41:
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data12
;program.c,47 :: 		if(packet[j+18]>60&&packet[j+18]<80)
	MOVLW       18
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       60
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data16
	MOVLW       18
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       80
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data16
L__conv_data32:
;program.c,49 :: 		temp2=temp2|(1<<(15-j));
	MOVF        R3, 0 
	SUBLW       15
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__conv_data42:
	BZ          L__conv_data43
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data42
L__conv_data43:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;program.c,50 :: 		}
	GOTO        L_conv_data17
L_conv_data16:
;program.c,51 :: 		else if(packet[j+18]>0&&packet[j+18]<40)
	MOVLW       18
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data20
	MOVLW       18
	ADDWF       R3, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R4, 0 
	MOVWF       R1 
	MOVLW       _packet+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       40
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data20
L__conv_data31:
;program.c,53 :: 		temp2=temp2|(0<<(15-j));
	MOVF        R3, 0 
	SUBLW       15
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	CLRF        R0 
	CLRF        R1 
	MOVF        R2, 0 
L__conv_data44:
	BZ          L__conv_data45
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data44
L__conv_data45:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;program.c,54 :: 		}
L_conv_data20:
L_conv_data17:
;program.c,45 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;program.c,55 :: 		}
	GOTO        L_conv_data11
L_conv_data12:
;program.c,58 :: 		temp=temp2;
	MOVF        conv_data_temp2_L0+0, 0 
	MOVWF       _temp+0 
	MOVF        conv_data_temp2_L0+1, 0 
	MOVWF       _temp+1 
;program.c,59 :: 		humidity=temp1;
	MOVF        conv_data_temp1_L0+0, 0 
	MOVWF       _humidity+0 
	MOVF        conv_data_temp1_L0+1, 0 
	MOVWF       _humidity+1 
;program.c,61 :: 		}
	RETURN      0
; end of _conv_data

_interrupt:

;program.c,65 :: 		void interrupt()
;program.c,67 :: 		if(INTCON.INT0IF==1)
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt21
;program.c,69 :: 		if(ff==1&&dht22==0)   // falling interrupt
	MOVLW       0
	XORWF       _ff+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt47
	MOVLW       1
	XORWF       _ff+0, 0 
L__interrupt47:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
	BTFSC       RB0_bit+0, 0 
	GOTO        L_interrupt24
L__interrupt35:
;program.c,71 :: 		packet[index] = TMR0L;
	MOVLW       _packet+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_packet+0)
	MOVWF       FSR1H 
	MOVF        _index+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        TMR0L+0, 0 
	MOVWF       POSTINC1+0 
;program.c,72 :: 		index++;
	INCF        _index+0, 1 
;program.c,73 :: 		ff=0;
	CLRF        _ff+0 
	CLRF        _ff+1 
;program.c,74 :: 		INTCON2.INTEDG0=1;
	BSF         INTCON2+0, 6 
;program.c,75 :: 		}
L_interrupt24:
;program.c,76 :: 		if(dht22==1)  // rising interrupt
	BTFSS       RB0_bit+0, 0 
	GOTO        L_interrupt25
;program.c,78 :: 		ff=1;
	MOVLW       1
	MOVWF       _ff+0 
	MOVLW       0
	MOVWF       _ff+1 
;program.c,79 :: 		INTCON2.INTEDG0=0;
	BCF         INTCON2+0, 6 
;program.c,80 :: 		TMR0L=0;               //timer 0 = 0
	CLRF        TMR0L+0 
;program.c,81 :: 		}
L_interrupt25:
;program.c,83 :: 		INTCON.INT0IF=0;
	BCF         INTCON+0, 1 
;program.c,84 :: 		}
L_interrupt21:
;program.c,87 :: 		}
L__interrupt46:
	RETFIE      1
; end of _interrupt

_main:

;program.c,90 :: 		void main() {
;program.c,94 :: 		INTCON=0b11000000; // RB0 interrupt when humditiy send data
	MOVLW       192
	MOVWF       INTCON+0 
;program.c,95 :: 		T0CON = 0b11000001; //page 105  timer 0 count every 1 u sec 8bit mode
	MOVLW       193
	MOVWF       T0CON+0 
;program.c,96 :: 		trisb0_bit=1; //RB0 input
	BSF         TRISB0_bit+0, 0 
;program.c,97 :: 		INTCON2.INTEDG0=0;   //interrupt at falling edge
	BCF         INTCON2+0, 6 
;program.c,98 :: 		uart1_init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;program.c,99 :: 		while(1)
L_main26:
;program.c,101 :: 		if(uart1_data_ready())
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;program.c,103 :: 		x=uart1_read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _x+0 
;program.c,104 :: 		if(x=='1')
	MOVF        R0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main29
;program.c,106 :: 		start();
	CALL        _start+0, 0
;program.c,107 :: 		}
L_main29:
;program.c,108 :: 		}
L_main28:
;program.c,109 :: 		if(index>=num)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _num+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main48
	MOVF        _num+0, 0 
	SUBWF       _index+0, 0 
L__main48:
	BTFSS       STATUS+0, 0 
	GOTO        L_main30
;program.c,111 :: 		INTCON.INT0IE=0;   // stop interrupt
	BCF         INTCON+0, 4 
;program.c,112 :: 		index=0;
	CLRF        _index+0 
;program.c,113 :: 		conv_data();
	CALL        _conv_data+0, 0
;program.c,114 :: 		uart1_write_text("temp=");
	MOVLW       ?lstr1_program+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_program+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;program.c,115 :: 		inttostr(temp,send2);
	MOVF        _temp+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _temp+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send2_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;program.c,116 :: 		uart1_write_text(send2);
	MOVLW       main_send2_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;program.c,117 :: 		uart1_write(13);          //new line
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;program.c,118 :: 		uart1_write_text("humidity=");
	MOVLW       ?lstr2_program+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_program+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;program.c,119 :: 		inttostr(humidity,send2);
	MOVF        _humidity+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _humidity+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send2_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;program.c,120 :: 		uart1_write_text(send2);
	MOVLW       main_send2_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;program.c,121 :: 		uart1_write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;program.c,122 :: 		}
L_main30:
;program.c,124 :: 		}
	GOTO        L_main26
;program.c,127 :: 		}
	GOTO        $+0
; end of _main
