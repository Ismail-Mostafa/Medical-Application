
_start:

;code.c,28 :: 		void start()
;code.c,30 :: 		dht22=0;
	BCF         RB0_bit+0, 0 
;code.c,31 :: 		trisb0_bit=0; // rb0 output
	BCF         TRISB0_bit+0, 0 
;code.c,32 :: 		delay_ms(5);
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
;code.c,33 :: 		trisb0_bit=1;  // rb0 input
	BSF         TRISB0_bit+0, 0 
;code.c,34 :: 		dht22=1;
	BSF         RB0_bit+0, 0 
;code.c,35 :: 		INTCON2.INTEDG0=0; // interrupt with falling edge
	BCF         INTCON2+0, 6 
;code.c,36 :: 		INTCON.INT0IE=1;    // Enable interrupt
	BSF         INTCON+0, 4 
;code.c,37 :: 		}
	RETURN      0
; end of _start

_conv_data:

;code.c,39 :: 		void conv_data()
;code.c,41 :: 		unsigned int temp1=0;
	CLRF        conv_data_temp1_L0+0 
	CLRF        conv_data_temp1_L0+1 
;code.c,42 :: 		unsigned int temp2=0;
	CLRF        conv_data_temp2_L0+0 
	CLRF        conv_data_temp2_L0+1 
;code.c,45 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data1:
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conv_data58
	MOVLW       16
	SUBWF       R3, 0 
L__conv_data58:
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data2
;code.c,47 :: 		if(packet[j+2]>60&&packet[j+2]<80)   // one
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
L__conv_data51:
;code.c,49 :: 		temp1=temp1|(1<<(15-j));
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
L__conv_data59:
	BZ          L__conv_data60
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data59
L__conv_data60:
	MOVF        R0, 0 
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;code.c,50 :: 		}
	GOTO        L_conv_data7
L_conv_data6:
;code.c,51 :: 		else if(packet[j+2]>0&&packet[j+2]<40)    //zero
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
L__conv_data50:
;code.c,53 :: 		temp1=temp1|(0<<(15-j));
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
L__conv_data61:
	BZ          L__conv_data62
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data61
L__conv_data62:
	MOVF        R0, 0 
	IORWF       conv_data_temp1_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp1_L0+1, 1 
;code.c,54 :: 		}
L_conv_data10:
L_conv_data7:
;code.c,45 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;code.c,55 :: 		}
	GOTO        L_conv_data1
L_conv_data2:
;code.c,57 :: 		for(j=0;j<16;j++)
	CLRF        R3 
	CLRF        R4 
L_conv_data11:
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conv_data63
	MOVLW       16
	SUBWF       R3, 0 
L__conv_data63:
	BTFSC       STATUS+0, 0 
	GOTO        L_conv_data12
;code.c,59 :: 		if(packet[j+18]>60&&packet[j+18]<80)
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
L__conv_data49:
;code.c,61 :: 		temp2=temp2|(1<<(15-j));
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
L__conv_data64:
	BZ          L__conv_data65
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data64
L__conv_data65:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;code.c,62 :: 		}
	GOTO        L_conv_data17
L_conv_data16:
;code.c,63 :: 		else if(packet[j+18]>0&&packet[j+18]<40)
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
L__conv_data48:
;code.c,65 :: 		temp2=temp2|(0<<(15-j));
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
L__conv_data66:
	BZ          L__conv_data67
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__conv_data66
L__conv_data67:
	MOVF        R0, 0 
	IORWF       conv_data_temp2_L0+0, 1 
	MOVF        R1, 0 
	IORWF       conv_data_temp2_L0+1, 1 
;code.c,66 :: 		}
L_conv_data20:
L_conv_data17:
;code.c,57 :: 		for(j=0;j<16;j++)
	INFSNZ      R3, 1 
	INCF        R4, 1 
;code.c,67 :: 		}
	GOTO        L_conv_data11
L_conv_data12:
;code.c,70 :: 		temp=temp2;
	MOVF        conv_data_temp2_L0+0, 0 
	MOVWF       _temp+0 
	MOVF        conv_data_temp2_L0+1, 0 
	MOVWF       _temp+1 
;code.c,71 :: 		humidity=temp1;
	MOVF        conv_data_temp1_L0+0, 0 
	MOVWF       _humidity+0 
	MOVF        conv_data_temp1_L0+1, 0 
	MOVWF       _humidity+1 
;code.c,73 :: 		}
	RETURN      0
; end of _conv_data

_interrupt:

;code.c,77 :: 		void interrupt()
;code.c,79 :: 		if(PIR1.TMR1IF==1)
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt21
;code.c,81 :: 		sec++;
	INFSNZ      _sec+0, 1 
	INCF        _sec+1, 1 
;code.c,82 :: 		if(sec>=500)
	MOVLW       128
	XORWF       _sec+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt69
	MOVLW       244
	SUBWF       _sec+0, 0 
L__interrupt69:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt22
;code.c,84 :: 		total_rate=rate*4;
	MOVF        _rate+0, 0 
	MOVWF       _total_rate+0 
	MOVF        _rate+1, 0 
	MOVWF       _total_rate+1 
	RLCF        _total_rate+0, 1 
	BCF         _total_rate+0, 0 
	RLCF        _total_rate+1, 1 
	RLCF        _total_rate+0, 1 
	BCF         _total_rate+0, 0 
	RLCF        _total_rate+1, 1 
;code.c,85 :: 		sec=0;
	CLRF        _sec+0 
	CLRF        _sec+1 
;code.c,86 :: 		heart_rate_flag=1;
	MOVLW       1
	MOVWF       _heart_rate_flag+0 
	MOVLW       0
	MOVWF       _heart_rate_flag+1 
;code.c,87 :: 		rate=0;
	CLRF        _rate+0 
	CLRF        _rate+1 
;code.c,88 :: 		}
L_interrupt22:
;code.c,89 :: 		PIR1.TMR1IF=0;
	BCF         PIR1+0, 0 
;code.c,90 :: 		TMR1L=0xDB;//     3035
	MOVLW       219
	MOVWF       TMR1L+0 
;code.c,91 :: 		TMR1H=0x0B;
	MOVLW       11
	MOVWF       TMR1H+0 
;code.c,92 :: 		}
L_interrupt21:
;code.c,96 :: 		if(INTCON.INT0IF==1)
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt23
;code.c,98 :: 		if(ff==1&&dht22==0)   // falling interrupt
	MOVLW       0
	XORWF       _ff+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt70
	MOVLW       1
	XORWF       _ff+0, 0 
L__interrupt70:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
	BTFSC       RB0_bit+0, 0 
	GOTO        L_interrupt26
L__interrupt52:
;code.c,100 :: 		packet[index] = TMR0L;
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
;code.c,101 :: 		index++;
	INCF        _index+0, 1 
;code.c,102 :: 		ff=0;
	CLRF        _ff+0 
	CLRF        _ff+1 
;code.c,103 :: 		INTCON2.INTEDG0=1;
	BSF         INTCON2+0, 6 
;code.c,104 :: 		}
L_interrupt26:
;code.c,105 :: 		if(dht22==1)  // rising interrupt
	BTFSS       RB0_bit+0, 0 
	GOTO        L_interrupt27
;code.c,107 :: 		ff=1;
	MOVLW       1
	MOVWF       _ff+0 
	MOVLW       0
	MOVWF       _ff+1 
;code.c,108 :: 		INTCON2.INTEDG0=0;
	BCF         INTCON2+0, 6 
;code.c,109 :: 		TMR0L=0;               //timer 0 = 0
	CLRF        TMR0L+0 
;code.c,110 :: 		}
L_interrupt27:
;code.c,112 :: 		INTCON.INT0IF=0;
	BCF         INTCON+0, 1 
;code.c,113 :: 		}
L_interrupt23:
;code.c,116 :: 		}
L__interrupt68:
	RETFIE      1
; end of _interrupt

_main:

;code.c,119 :: 		void main() {
;code.c,124 :: 		INTCON=0b11000000; // RB0 interrupt when humditiy send data
	MOVLW       192
	MOVWF       INTCON+0 
;code.c,125 :: 		T0CON = 0b11000001; //page 105  timer 0 count every 1 u sec 8bit mode
	MOVLW       193
	MOVWF       T0CON+0 
;code.c,126 :: 		trisb0_bit=1; //RB0 input
	BSF         TRISB0_bit+0, 0 
;code.c,127 :: 		INTCON2.INTEDG0=0;   //interrupt at falling edge
	BCF         INTCON2+0, 6 
;code.c,128 :: 		uart1_init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;code.c,129 :: 		T1CON=10110101;    //62500
	MOVLW       149
	MOVWF       T1CON+0 
;code.c,130 :: 		PIE1.TMR1IE=1;
	BSF         PIE1+0, 0 
;code.c,131 :: 		IPR1.TMR1IP=1;
	BSF         IPR1+0, 0 
;code.c,132 :: 		TMR1L=0xDB;        //3035
	MOVLW       219
	MOVWF       TMR1L+0 
;code.c,133 :: 		TMR1H=0x0B;
	MOVLW       11
	MOVWF       TMR1H+0 
;code.c,134 :: 		while(1)
L_main28:
;code.c,137 :: 		heart=adc_read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _heart+0 
	MOVF        R1, 0 
	MOVWF       _heart+1 
;code.c,138 :: 		if(heart>550&&flag==0)
	MOVLW       128
	XORLW       2
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main71
	MOVF        R0, 0 
	SUBLW       38
L__main71:
	BTFSC       STATUS+0, 0 
	GOTO        L_main32
	MOVLW       0
	XORWF       _flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main72
	MOVLW       0
	XORWF       _flag+0, 0 
L__main72:
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
L__main57:
;code.c,140 :: 		rate++;
	INFSNZ      _rate+0, 1 
	INCF        _rate+1, 1 
;code.c,141 :: 		flag=1;
	MOVLW       1
	MOVWF       _flag+0 
	MOVLW       0
	MOVWF       _flag+1 
;code.c,143 :: 		}
L_main32:
;code.c,144 :: 		if(heart<450&&flag==1)
	MOVLW       128
	XORWF       _heart+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main73
	MOVLW       194
	SUBWF       _heart+0, 0 
L__main73:
	BTFSC       STATUS+0, 0 
	GOTO        L_main35
	MOVLW       0
	XORWF       _flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main74
	MOVLW       1
	XORWF       _flag+0, 0 
L__main74:
	BTFSS       STATUS+0, 2 
	GOTO        L_main35
L__main56:
;code.c,145 :: 		flag=0;
	CLRF        _flag+0 
	CLRF        _flag+1 
L_main35:
;code.c,148 :: 		angle=((adc_read(1)-270)*1.3846);       //Temperature EQU
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVLW       14
	SUBWF       R0, 1 
	MOVLW       1
	SUBWFB      R1, 1 
	CALL        _Word2Double+0, 0
	MOVLW       147
	MOVWF       R4 
	MOVLW       58
	MOVWF       R5 
	MOVLW       49
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Int+0, 0
	MOVF        R0, 0 
	MOVWF       _angle+0 
	MOVF        R1, 0 
	MOVWF       _angle+1 
;code.c,149 :: 		inttostr(angle,send);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;code.c,152 :: 		if((angle>150||angle<30)&&angle_flag==0)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _angle+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main75
	MOVF        _angle+0, 0 
	SUBLW       150
L__main75:
	BTFSS       STATUS+0, 0 
	GOTO        L__main55
	MOVLW       128
	XORWF       _angle+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main76
	MOVLW       30
	SUBWF       _angle+0, 0 
L__main76:
	BTFSS       STATUS+0, 0 
	GOTO        L__main55
	GOTO        L_main40
L__main55:
	MOVLW       0
	XORWF       _angle_flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main77
	MOVLW       0
	XORWF       _angle_flag+0, 0 
L__main77:
	BTFSS       STATUS+0, 2 
	GOTO        L_main40
L__main54:
;code.c,154 :: 		uart1_write_text("fall");
	MOVLW       ?lstr1_code+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_code+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;code.c,155 :: 		angle_flag=1;
	MOVLW       1
	MOVWF       _angle_flag+0 
	MOVLW       0
	MOVWF       _angle_flag+1 
;code.c,156 :: 		}
L_main40:
;code.c,157 :: 		if((angle<110&&angle>70))
	MOVLW       128
	XORWF       _angle+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main78
	MOVLW       110
	SUBWF       _angle+0, 0 
L__main78:
	BTFSC       STATUS+0, 0 
	GOTO        L_main43
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _angle+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main79
	MOVF        _angle+0, 0 
	SUBLW       70
L__main79:
	BTFSC       STATUS+0, 0 
	GOTO        L_main43
L__main53:
;code.c,158 :: 		angle_flag=0;
	CLRF        _angle_flag+0 
	CLRF        _angle_flag+1 
L_main43:
;code.c,160 :: 		if(uart1_data_ready())
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main44
;code.c,162 :: 		x=uart1_read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _x+0 
;code.c,163 :: 		if(x=='1')
	MOVF        R0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main45
;code.c,166 :: 		}
L_main45:
;code.c,167 :: 		}
L_main44:
;code.c,168 :: 		if(heart_rate_flag==1)
	MOVLW       0
	XORWF       _heart_rate_flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main80
	MOVLW       1
	XORWF       _heart_rate_flag+0, 0 
L__main80:
	BTFSS       STATUS+0, 2 
	GOTO        L_main46
;code.c,170 :: 		uart1_write_text("Heart Rate=");
	MOVLW       ?lstr2_code+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_code+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;code.c,171 :: 		inttostr(total_rate,send2);
	MOVF        _total_rate+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _total_rate+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_send2_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;code.c,172 :: 		uart1_write_text(send2);
	MOVLW       main_send2_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_send2_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;code.c,173 :: 		uart1_write(13);          //new line
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,174 :: 		heart_rate_flag=0;
	CLRF        _heart_rate_flag+0 
	CLRF        _heart_rate_flag+1 
;code.c,175 :: 		start();
	CALL        _start+0, 0
;code.c,176 :: 		}
L_main46:
;code.c,177 :: 		if(index>=num)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _num+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main81
	MOVF        _num+0, 0 
	SUBWF       _index+0, 0 
L__main81:
	BTFSS       STATUS+0, 0 
	GOTO        L_main47
;code.c,179 :: 		INTCON.INT0IE=0;   // stop interrupt
	BCF         INTCON+0, 4 
;code.c,180 :: 		index=0;
	CLRF        _index+0 
;code.c,181 :: 		conv_data();
	CALL        _conv_data+0, 0
;code.c,182 :: 		uart1_write_text("temp=");
	MOVLW       ?lstr3_code+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_code+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;code.c,183 :: 		a=temp/100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp+0, 0 
	MOVWF       R0 
	MOVF        _temp+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       main_a_L0+0 
	MOVF        R1, 0 
	MOVWF       main_a_L0+1 
;code.c,184 :: 		b=(temp%100)/10;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp+0, 0 
	MOVWF       R0 
	MOVF        _temp+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       main_b_L0+0 
	MOVF        R1, 0 
	MOVWF       main_b_L0+1 
;code.c,185 :: 		c=(temp%100)%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       main_c_L0+0 
	MOVF        R1, 0 
	MOVWF       main_c_L0+1 
;code.c,187 :: 		uart1_write(a+48);
	MOVLW       48
	ADDWF       main_a_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,188 :: 		uart1_write(b+48);
	MOVLW       48
	ADDWF       main_b_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,189 :: 		uart1_write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,190 :: 		uart1_write(c+48);
	MOVLW       48
	ADDWF       main_c_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,191 :: 		uart1_write(13);          //new line
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,192 :: 		uart1_write_text("humidity=");
	MOVLW       ?lstr4_code+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_code+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;code.c,193 :: 		a=humidity/100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _humidity+0, 0 
	MOVWF       R0 
	MOVF        _humidity+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       main_a_L0+0 
	MOVF        R1, 0 
	MOVWF       main_a_L0+1 
;code.c,194 :: 		b=(humidity%100)/10;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _humidity+0, 0 
	MOVWF       R0 
	MOVF        _humidity+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       main_b_L0+0 
	MOVF        R1, 0 
	MOVWF       main_b_L0+1 
;code.c,195 :: 		c=(humidity%100)%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       main_c_L0+0 
	MOVF        R1, 0 
	MOVWF       main_c_L0+1 
;code.c,197 :: 		uart1_write(a+48);
	MOVLW       48
	ADDWF       main_a_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,198 :: 		uart1_write(b+48);
	MOVLW       48
	ADDWF       main_b_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,199 :: 		uart1_write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,200 :: 		uart1_write(c+48);
	MOVLW       48
	ADDWF       main_c_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,201 :: 		uart1_write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;code.c,202 :: 		}
L_main47:
;code.c,204 :: 		}
	GOTO        L_main28
;code.c,207 :: 		}
	GOTO        $+0
; end of _main
