
_start:

;test1.c,16 :: 		void start()
;test1.c,18 :: 		dht22=0;
	BCF         RB0_bit+0, 0 
;test1.c,19 :: 		trisb0_bit=0;
	BCF         TRISB0_bit+0, 0 
;test1.c,20 :: 		delay_ms(5);
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
;test1.c,21 :: 		trisb0_bit=1;
	BSF         TRISB0_bit+0, 0 
;test1.c,22 :: 		dht22=1;
	BSF         RB0_bit+0, 0 
;test1.c,23 :: 		INTCON2.INTEDG0=0;
	BCF         INTCON2+0, 6 
;test1.c,24 :: 		INTCON.INT0IE=1;
	BSF         INTCON+0, 4 
;test1.c,25 :: 		}
	RETURN      0
; end of _start

_conv_data:

;test1.c,27 :: 		void conv_data()
;test1.c,29 :: 		unsigned int temp1=0;
	CLRF        conv_data_temp1_L0+0 
	CLRF        conv_data_temp1_L0+1 
;test1.c,30 :: 		unsigned int temp2=0;
	CLRF        conv_data_temp2_L0+0 
	CLRF        conv_data_temp2_L0+1 
;test1.c,33 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data1:
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
	GOTO        L_conv_data2
;test1.c,35 :: 		if(packet[j+2]>60&&packet[j+2]<80)
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
L__conv_data39:
;test1.c,37 :: 		temp1=temp1|(1<<(15-j));
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
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;test1.c,38 :: 		}
	GOTO        L_conv_data7
L_conv_data6:
;test1.c,39 :: 		else if(packet[j+2]>0&&packet[j+2]<40)
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
L__conv_data38:
;test1.c,41 :: 		temp1=temp1|(0<<(15-j));
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
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;test1.c,42 :: 		}
L_conv_data10:
L_conv_data7:
;test1.c,33 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;test1.c,43 :: 		}
	GOTO        L_conv_data1
L_conv_data2:
;test1.c,45 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data11:
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conv_data46
	MOVLW       16
	SUBWF       R3, 0 
L__conv_data46:
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data12
;test1.c,47 :: 		if(packet[j+18]>60&&packet[j+18]<80)
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
L__conv_data37:
;test1.c,49 :: 		temp2=temp2|(1<<(15-j));
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
L__conv_data47:
	BZ          L__conv_data48
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data47
L__conv_data48:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;test1.c,50 :: 		}
	GOTO        L_conv_data17
L_conv_data16:
;test1.c,51 :: 		else if(packet[j+18]>0&&packet[j+18]<40)
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
L__conv_data36:
;test1.c,53 :: 		temp2=temp2|(0<<(15-j));
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
L__conv_data49:
	BZ          L__conv_data50
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data49
L__conv_data50:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;test1.c,54 :: 		}
L_conv_data20:
L_conv_data17:
;test1.c,45 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;test1.c,55 :: 		}
	GOTO        L_conv_data11
L_conv_data12:
;test1.c,58 :: 		temp=temp2;
	MOVF        conv_data_temp2_L0+0, 0 
	MOVWF       _temp+0 
	MOVF        conv_data_temp2_L0+1, 0 
	MOVWF       _temp+1 
;test1.c,59 :: 		humidity=temp1;
	MOVF        conv_data_temp1_L0+0, 0 
	MOVWF       _humidity+0 
	MOVF        conv_data_temp1_L0+1, 0 
	MOVWF       _humidity+1 
;test1.c,64 :: 		}
	RETURN      0
; end of _conv_data

_read_data:

;test1.c,66 :: 		void read_data()
;test1.c,71 :: 		}
	RETURN      0
; end of _read_data

_interrupt:

;test1.c,75 :: 		void interrupt()
;test1.c,77 :: 		if(INTCON.INT0IF==1)
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt21
;test1.c,79 :: 		if(ff==1&&dht22==0)
	MOVLW       0
	XORWF       _ff+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt52
	MOVLW       1
	XORWF       _ff+0, 0 
L__interrupt52:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
	BTFSC       RB0_bit+0, 0 
	GOTO        L_interrupt24
L__interrupt40:
;test1.c,81 :: 		packet[index] = TMR0L;
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
;test1.c,82 :: 		index++;
	INCF        _index+0, 1 
;test1.c,83 :: 		ff=0;
	CLRF        _ff+0 
	CLRF        _ff+1 
;test1.c,84 :: 		INTCON2.INTEDG0=1;
	BSF         INTCON2+0, 6 
;test1.c,85 :: 		}
L_interrupt24:
;test1.c,88 :: 		if(dht22==1)
	BTFSS       RB0_bit+0, 0 
	GOTO        L_interrupt25
;test1.c,90 :: 		ff=1;
	MOVLW       1
	MOVWF       _ff+0 
	MOVLW       0
	MOVWF       _ff+1 
;test1.c,91 :: 		INTCON2.INTEDG0=0;
	BCF         INTCON2+0, 6 
;test1.c,92 :: 		TMR0L=0;
	CLRF        TMR0L+0 
;test1.c,93 :: 		}
L_interrupt25:
;test1.c,95 :: 		INTCON.INT0IF=0;
	BCF         INTCON+0, 1 
;test1.c,97 :: 		}
L_interrupt21:
;test1.c,100 :: 		}
L__interrupt51:
	RETFIE      1
; end of _interrupt

_main:

;test1.c,103 :: 		void main() {
;test1.c,107 :: 		INTCON=0b11000000; // RB0 interrupt when humditiy send data
	MOVLW       192
	MOVWF       INTCON+0 
;test1.c,108 :: 		T0CON = 0b11000001; //page 105  timer 0 count every 1 u sec 8bit mode
	MOVLW       193
	MOVWF       T0CON+0 
;test1.c,109 :: 		trisb0_bit=1; //RB0 input
	BSF         TRISB0_bit+0, 0 
;test1.c,110 :: 		INTCON2.INTEDG0=0;   //interrupt at falling edge
	BCF         INTCON2+0, 6 
;test1.c,111 :: 		uart1_init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;test1.c,112 :: 		uart1_write_text("ready");
	MOVLW       ?lstr1_test1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_test1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,113 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main26:
	DECFSZ      R13, 1, 0
	BRA         L_main26
	DECFSZ      R12, 1, 0
	BRA         L_main26
	DECFSZ      R11, 1, 0
	BRA         L_main26
	NOP
	NOP
;test1.c,114 :: 		uart1_write_text("ready");
	MOVLW       ?lstr2_test1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_test1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,115 :: 		while(1)
L_main27:
;test1.c,117 :: 		if(uart1_data_ready())
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
;test1.c,119 :: 		x=uart1_read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _x+0 
;test1.c,120 :: 		if(x=='1')
	MOVF        R0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
;test1.c,122 :: 		start();
	CALL        _start+0, 0
;test1.c,123 :: 		}
L_main30:
;test1.c,124 :: 		}
L_main29:
;test1.c,125 :: 		if(index>=num)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _num+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main53
	MOVF        _num+0, 0 
	SUBWF       _index+0, 0 
L__main53:
	BTFSS       STATUS+0, 0 
	GOTO        L_main31
;test1.c,127 :: 		INTCON.INT0IE=0;
	BCF         INTCON+0, 4 
;test1.c,128 :: 		for(i=0;i<num;i++)
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
L_main32:
	MOVLW       128
	XORWF       main_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _num+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main54
	MOVF        _num+0, 0 
	SUBWF       main_i_L0+0, 0 
L__main54:
	BTFSC       STATUS+0, 0 
	GOTO        L_main33
;test1.c,130 :: 		bytetostr(packet[i],send);
	MOVLW       _packet+0
	ADDWF       main_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_packet+0)
	ADDWFC      main_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       main_send_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(main_send_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;test1.c,131 :: 		uart1_write_text(send);
	MOVLW       main_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,132 :: 		uart1_write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;test1.c,133 :: 		if(i==18)
	MOVLW       0
	XORWF       main_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main55
	MOVLW       18
	XORWF       main_i_L0+0, 0 
L__main55:
	BTFSS       STATUS+0, 2 
	GOTO        L_main35
;test1.c,135 :: 		uart1_write_text("humidity");
	MOVLW       ?lstr3_test1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_test1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,136 :: 		}
L_main35:
;test1.c,128 :: 		for(i=0;i<num;i++)
	INFSNZ      main_i_L0+0, 1 
	INCF        main_i_L0+1, 1 
;test1.c,137 :: 		}
	GOTO        L_main32
L_main33:
;test1.c,138 :: 		index=0;
	CLRF        _index+0 
;test1.c,139 :: 		conv_data();
	CALL        _conv_data+0, 0
;test1.c,140 :: 		uart1_write_text("temp=");
	MOVLW       ?lstr4_test1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_test1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,141 :: 		inttostr(temp,send2);
	MOVF        _temp+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _temp+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send2_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;test1.c,142 :: 		uart1_write_text(send2);
	MOVLW       main_send2_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,143 :: 		uart1_write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;test1.c,144 :: 		uart1_write_text("humidity=");
	MOVLW       ?lstr5_test1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_test1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,145 :: 		inttostr(humidity,send2);
	MOVF        _humidity+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _humidity+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send2_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;test1.c,146 :: 		uart1_write_text(send2);
	MOVLW       main_send2_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;test1.c,147 :: 		uart1_write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;test1.c,148 :: 		}
L_main31:
;test1.c,150 :: 		}
	GOTO        L_main27
;test1.c,153 :: 		}
	GOTO        $+0
; end of _main
