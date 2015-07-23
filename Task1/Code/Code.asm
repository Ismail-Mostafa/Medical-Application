
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Code.c,5 :: 		void interrupt()
;Code.c,7 :: 		if(PIR1.TMR1IF==1)
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt0
;Code.c,9 :: 		sec++;
	INCF       _sec+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sec+1, 1
;Code.c,10 :: 		if(sec==22)
	MOVLW      0
	XORWF      _sec+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt12
	MOVLW      22
	XORWF      _sec+0, 0
L__interrupt12:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;Code.c,12 :: 		heart_rate=TMR0*4;
	MOVF       TMR0+0, 0
	MOVWF      _heart_rate+0
	CLRF       _heart_rate+1
	RLF        _heart_rate+0, 1
	RLF        _heart_rate+1, 1
	BCF        _heart_rate+0, 0
	RLF        _heart_rate+0, 1
	RLF        _heart_rate+1, 1
	BCF        _heart_rate+0, 0
;Code.c,13 :: 		sec=0;
	CLRF       _sec+0
	CLRF       _sec+1
;Code.c,14 :: 		TMR0=0;
	CLRF       TMR0+0
;Code.c,15 :: 		heart_rate_flag=1;
	MOVLW      1
	MOVWF      _heart_rate_flag+0
	MOVLW      0
	MOVWF      _heart_rate_flag+1
;Code.c,16 :: 		}
L_interrupt1:
;Code.c,17 :: 		PIR1.TMR1IF=0;
	BCF        PIR1+0, 0
;Code.c,18 :: 		TMR1L=0xDB;//     3035
	MOVLW      219
	MOVWF      TMR1L+0
;Code.c,19 :: 		TMR1H=0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;Code.c,20 :: 		}
L_interrupt0:
;Code.c,22 :: 		}
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Code.c,24 :: 		void main() {
;Code.c,31 :: 		OPTION_REG.T0CS=1;   //Timer0 as counter
	BSF        OPTION_REG+0, 5
;Code.c,36 :: 		T1CON=0b00110101;   //62500  *8 precsacle = 0.5 sec
	MOVLW      53
	MOVWF      T1CON+0
;Code.c,37 :: 		TMR1L=0xDB;        //3035
	MOVLW      219
	MOVWF      TMR1L+0
;Code.c,38 :: 		TMR1H=0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;Code.c,42 :: 		INTCON.GIE=1;
	BSF        INTCON+0, 7
;Code.c,43 :: 		INTCON.PEIE=1;
	BSF        INTCON+0, 6
;Code.c,44 :: 		PIE1.TMR1IE=1;
	BSF        PIE1+0, 0
;Code.c,49 :: 		uart1_init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Code.c,50 :: 		while(1)
L_main2:
;Code.c,55 :: 		if(uart1_data_ready())
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;Code.c,57 :: 		Rx=uart1_read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _Rx+0
;Code.c,58 :: 		uart1_write(Rx);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Code.c,59 :: 		TMR0=0;
	CLRF       TMR0+0
;Code.c,60 :: 		TMR1L=0xDB;//     3035
	MOVLW      219
	MOVWF      TMR1L+0
;Code.c,61 :: 		TMR1H=0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;Code.c,62 :: 		}
L_main4:
;Code.c,63 :: 		if(Rx=='s')
	MOVF       _Rx+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;Code.c,65 :: 		if(heart_rate_flag==1)
	MOVLW      0
	XORWF      _heart_rate_flag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      1
	XORWF      _heart_rate_flag+0, 0
L__main13:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;Code.c,67 :: 		uart1_write_text("Heart Rate= ");
	MOVLW      ?lstr1_Code+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,68 :: 		inttostr(heart_rate,txt);
	MOVF       _heart_rate+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _heart_rate+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Code.c,69 :: 		uart1_write_text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,70 :: 		uart1_write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Code.c,72 :: 		t=adc_read(0)*0.4887;       //Temperature EQU
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _Word2Double+0
	MOVLW      227
	MOVWF      R4+0
	MOVLW      54
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _Double2Int+0
;Code.c,73 :: 		inttostr(t,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Code.c,74 :: 		uart1_write_text("Temperature= ");
	MOVLW      ?lstr2_Code+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,75 :: 		uart1_write_text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,76 :: 		heart_rate_flag=0;
	CLRF       _heart_rate_flag+0
	CLRF       _heart_rate_flag+1
;Code.c,77 :: 		uart1_write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Code.c,78 :: 		angel=((adc_read(1)-270)*1.3846);       //Temperature EQU
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      14
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      1
	SUBWF      R0+1, 1
	CALL       _Word2Double+0
	MOVLW      147
	MOVWF      R4+0
	MOVLW      58
	MOVWF      R4+1
	MOVLW      49
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _Double2Int+0
	MOVF       R0+0, 0
	MOVWF      main_angel_L0+0
	MOVF       R0+1, 0
	MOVWF      main_angel_L0+1
;Code.c,79 :: 		inttostr(angel,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Code.c,80 :: 		uart1_write_text("Angel= ");
	MOVLW      ?lstr3_Code+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,81 :: 		uart1_write_text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,82 :: 		if(angel>150||angel<30)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_angel_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main14
	MOVF       main_angel_L0+0, 0
	SUBLW      150
L__main14:
	BTFSS      STATUS+0, 0
	GOTO       L__main10
	MOVLW      128
	XORWF      main_angel_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main15
	MOVLW      30
	SUBWF      main_angel_L0+0, 0
L__main15:
	BTFSS      STATUS+0, 0
	GOTO       L__main10
	GOTO       L_main9
L__main10:
;Code.c,84 :: 		uart1_write_text("fall");
	MOVLW      ?lstr4_Code+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Code.c,85 :: 		}
L_main9:
;Code.c,87 :: 		heart_rate_flag=0;
	CLRF       _heart_rate_flag+0
	CLRF       _heart_rate_flag+1
;Code.c,88 :: 		uart1_write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Code.c,89 :: 		}
L_main6:
;Code.c,91 :: 		}
L_main5:
;Code.c,92 :: 		}
	GOTO       L_main2
;Code.c,94 :: 		}
	GOTO       $+0
; end of _main
