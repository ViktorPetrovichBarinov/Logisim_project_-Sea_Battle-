	asect 0x00
 	setsp 0xef
START:
	jsr check_end_message
	ldi r0, 0xfc
	ldi r1, 0
	jsr print_field
#В начале программы выводиться приветственное сообщение 
#Проверяем, что приветственное сообщение завершилось
#И выводим второе сообщение
	jsr check_end_message
	ldi r0, 6
	stv r0, 0xff

#Опять проверка, что сообщение закончилось и пользователь готов к следующему
#Вывод следующего сообщения с тем какие коробли имеются
	jsr check_end_message
	ldi r0, 19
	stv r0, 0xff
#Снова проверка конца сообщения и пользователя

#Расставляем корабль длинны 4	
	jsr ship_placement_len4





	halt
	
	


# в r0 поставить
ship_placement_len4:
	setsp 0xef
#Просьба ввести первую координату корабля длинны 4
	jsr check_end_message
	ldi r0, 30
	stv r0, 0xff

# в r0 - буква
# в r1 - цифра
	jsr get_symbol_and_digit
# цифру в стэк	
	push r1 

#Проверяем, что это буква в пределах от A до J
	ldi r1, 65
	ldi r2, 75	
	jsr check_correct
#если она не в пределах, то
	if
		tst r1 
	is eq 
		jsr wrong_symbols
		jmp ship_placement_len4
	fi 
#достаём цифру
	pop r1 
#засовываем букву обратно в стэк
	push r0
	move r1, r0  
#Проверяем, что это цифра
	ldi r1, 49 
	ldi r2, 59 
	jsr check_correct
	if
		tst r1 
	is eq 
		pop r0 
		jsr wrong_symbols
		jmp ship_placement_len4
	fi 
#Пушим цифру в стэк
	pop r1
#Теперь в стэкэ лежат корректные буква и цифра



rts

#функция получает сначала букву а потом цифру
#В r0 - буква
#В r1 - цифра
get_symbol_and_digit:
#получаем считанный ASCII код в r0 - букву
	jsr check_keyboard 
#Если буква строчная, делаем её заглавной
	jsr low_to_up
	push r0 
	jsr nextSym
	#получаем считанный ASCII код в r0 - цифру
	jsr check_keyboard 
	push r0 
	jsr nextSym
	pop r1 
	pop r0

rts 

#функция выводит сообщение о том что введены некорректные символы
# и очищает клавиатуру
wrong_symbols: 
		jsr check_end_message
		ldi r0, 78
		stv r0, 0xff
		jsr clean_keyboard
rts 



#a - 0x61 j - 0x6a
#принимает в r0 символ и если это строчная буква, то делает её заглавной
#использует r1
low_to_up:
	ldi r1, 0x61

	if 
		cmp r0, r1 
	is pl 
		ldi r1, 0x6b 
		if
			cmp r0, r1 
		is mi 
			ldi r1, -0x20
			add r1, r0 
		fi
	fi 

#исправить в фразах пример A2 или a2
rts 

#   # В r0 - число котороенужно проверить
# 	# В r1 - нижняя граница [ включая 
# 	# В r2 - верхняя граница ) не включая
# 	# Это проверка на то что , у нас буквы от A до J и числа от 0 до 9
check_correct:
	if 
		cmp r0, r1 
	is mi
		clr r1
	fi

	if
		cmp r0, r2
	is pl
		clr r1
	fi
rts
		



# возвращает ASCII код в r0
# 0 - тактовый вход
# 1 - вкл выкл
# 2 - очистка
# 3 - 1 когда в буфере есть символ	
check_keyboard:
	ldi r0, 0xfe #управляющие биты клавиатуры |FE| 
	
	# в регистре с таким адресом лежит слежующий символ буфера
	# 0 если там никакого символа
	# не 0  если там  что-то есть
	ldi r1, 0b00001000 #битовая маска для прооверки что в буфере что-то есть
	ldi r2, 0
	while
		and r1, r2 # если в r3 лежит ноль, значит буфер пуст и мы ожидаем пока там что-то появиться
	stays eq
			# в третий регистр считываем биты клавиатуры
			# если они совпадают с битовой маской то в буфере что-то есть, а значит можн начать считывание
		ld r0, r2 
	wend
	ldi r1, 0xfd #символ ascii кода  БУКВА |FD| 
	ld r1, r0 # если мы вышли из цикла значит появился символ, по адресу 253
rts
	
	#использует r0 r1 r2
	#нет входных данных
check_end_message:
	ldi r0, 0xfe #адресс управления клавиатурой, используем самый страший
	ldi r1, 0b10000000
	ldi r2, 0
	while 
		and r1, r2
	stays eq
		ld r0, r2
	wend
	st r0, r1 
rts

nextSym:
	ldi r0, 254 #адресс управляющих битов клавиатуры
	ldi r1, 0b00000011 # загружаем в r1 маску которая говорит, включить клавиатуру и считывание
	st r0, r1 # загружаем в 254 адресс маску которая говорит, включить клавиатуру и считывание
	ldi r1, 0b00000000 # загружаем в r1 маску которая говорит, выключить клавиатуру и считывание
	st r0, r1 # загружаем в 254 адресс маску которая говорит, выключить клавиатуру и считывание
rts

clean_keyboard: 
	ldi r0, 0b00000100
	stv r0, 0xfe
	clr r0 
	stv r0, 0xfe 
rts
		 
	
	# использует все регистры
	# в r0 передаём адресс куда писать
	# 252 - игрок
	# --- - бот
	# в r1 передаём адресс начала поля которое хотим начать выводить
	# 0 - вывод поля игрока
	# 100 - вывод поля бота

	# пример вывода на потом
	# ldi r0, 252  
	# ldi r3, 100
	# jsr print_field
	# ldi r0, 250
	# ldi r3, 100
	# jsr print_field
	# halt
print_field:
	ldi r2, 72 
	stv r2, 0xff
#очищаем поле перед тем как печатать
	ldi r2, 31 
	st r0, r2
#печатаем " 0123456789"
	jsr print_fst_str
#вывод \n
	ldi r2, 27
	st r0, r2
#загружаем константы для печати "ABCDEFGHIJ"
	ldi r2, 16
	ldi r3, 25
	
	while
		cmp r2, r3 
	stays mi 
	#напечатали букву в конце сложили константы в стэк
		st r0, r2  
		push r3
		push r2 
	#выводим следующие 10 значений
		ldi r3, 10 
		while 
			tst r3 
		stays ne
			ld r1, r2 
			st r0, r2 
			dec r3 
			inc r1
		wend
	#вывели 10 значений
	#достаём константу отвечающую за буквы из стека
	#выводим букву
		pop r2
		st r0, r2
		inc r2 
	#выводим \n
		ldi r3, 27
		st r0, r3 
		pop r3 
	wend 
#печатаем " 0123456789"
	jsr print_fst_str
rts

print_fst_str: 
#загружаем константы для печати " 0123456789"
	ldi r2, 5
	ldi r3, 16
	
	while
		cmp r2, r3
	stays mi 
		st r0, r2
		inc r2
	wend
rts


	

	
	
end
