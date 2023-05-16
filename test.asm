	asect 0x00
 	setsp 0xdf
################################################################################################
#В следующем блоке происходят действия в начале программы
################################################################################################
#выводим сообщение 
	jsr check_end_message
#выводим поле
	jsr print_player_field
#В начале программы выводиться приветственное сообщение 
#И выводим второе сообщение
	jsr second_message
	jsr check_end_message
#Опять проверка, что сообщение закончилось и пользователь готов к следующему
#Вывод следующего сообщения с тем какие коробли имеются
	jsr third_message
#Проверка конца сообщения не нужна, потому что потом вызываем функцию расстановки корабле
################################################################################################

#####      #       ####     ####   #######     #     #    #    ####    #####   #   #     #                            
#    #    # #     #    #   #    #     #       # #    #    #   #    #   #    #  #  #     # #                  
#    #   #   #   #        #           #      #   #   #    #  #      #  #    #  # #     #   #        
#####   #     #  #        #           #     #     #  ######  #      #  #####   ##     #     #               
#       #######  #        #           #     #######  #    #  #      #  #    #  # #    #######           
#       #     #   #    #   #    #     #     #     #  #    #   #    #   #    #  #  #   #     #                      
#       #     #    ####     ####      #     #     #  #    #    ####    #####   #   #  #     #  

################################################################################################
#В следующем блоке расставляется на поле корабль длинны 4
################################################################################################
#Загружаем адресс сообщений в ячейку памяти	
	ldi r0, 30 
	stv r0, 0xf3
	ldi r0, 36 
	stv r0, 0xf4
#Загружаем разницу первой и второй координаты
	ldi r0, 3
	stv r0, 0xf2
#Запускаем функцию расстановки кораблей
	jsr ship_placement
#После того как поставили корабль сразу печатаем поле
	jsr print_player_field
#Печатаем сообщение о том, что корабль успешно поставлен
	jsr ship_deliver
	ldi r0, 4
	jsr plus_number_tails
######################################################################
#В Следубщем блоке делаем тоже что и при расстановки 4-х клеточного корабля, только с 3-х клеточным и два раза
######################################################################
	ldi r0, 42 
	stv r0, 0xf3
	ldi r0, 48 
	stv r0, 0xf4
	ldi r0, 2
	stv r0, 0xf2
	jsr ship_placement
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 3
	jsr plus_number_tails

	jsr ship_placement
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 3
	jsr plus_number_tails
######################################################################
#В Следубщем блоке делаем тоже что и при расстановки 4-х клеточного корабля, только с 2-х клеточным и три раза
######################################################################
	ldi r0, 54 
	stv r0, 0xf3
	ldi r0, 60 
	stv r0, 0xf4
	ldi r0, 1
	stv r0, 0xf2
	jsr ship_placement
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 2
	jsr plus_number_tails

	jsr ship_placement
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 2
	jsr plus_number_tails
	
	jsr ship_placement
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 2
	jsr plus_number_tails
######################################################################
#В Следубщем блоке делаем тоже что и при расстановки 4-х клеточного корабля, только с 1-о клеточным и три раза
######################################################################
	ldi r0, 66 
	stv r0, 0xf3
	ldi r0, 66 
	stv r0, 0xf4

	jsr ship_placement1
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 1
	jsr plus_number_tails

	jsr ship_placement1
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 1
	jsr plus_number_tails

	jsr ship_placement1
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 1
	jsr plus_number_tails

	jsr ship_placement1
	jsr print_player_field
	jsr ship_deliver
	ldi r0, 1
	jsr plus_number_tails

	halt
	
#в r0 передаём сколько хотим прибавить к тайлам игрока
plus_number_tails:
	push r1 
	ldv 0xf0, r1 
	add r0, r1 
	stv r1, 0xf0 
	pop r1 
rts 
ship_placement1:
	setsp 0xdd #отодвигает стэкпоинтер на два влево т.к. 2 байта занято под выход из функции

	jsr check_end_message
	ldv 0xf3, r0
	stv r0, 0xff
	jsr check_end_message
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
		jmp ship_placement1
	fi 
#достаём цифру
	pop r1 
#засовываем букву обратно в стэк
	push r0
	move r1, r0  
#Проверяем, что это цифра
	ldi r1, 48 
	ldi r2, 58 
	jsr check_correct
	if
		tst r1 
	is eq 
		pop r0 
		jsr wrong_symbols
		jmp ship_placement1
	fi 
	pop r1 
#В r0 цифра r1 - буква
	
	ldi r2, -65
	add r1, r2 
	shla r2
	move r2, r3 
	shla r3 
	shla r3 
	add r3, r2 
	ldi r3, -48 
	add r0, r3 
	add r3, r2 
	ld r2, r2 
	
	if 
		dec r2 
	is eq 
		jsr wrong_coordinates
		jmp ship_placement1
	fi 
	if 
		dec r2 
	is eq 
		jsr wrong_coordinates
		jmp ship_placement1
	fi 
	push r1 
	move r0, r1 
	pop r0
	
#r0 - буква r1 - цифра 
	jsr load
	jsr store_ship

rts 

ship_placement:
	setsp 0xdd #отодвигает стэкпоинтер на два влево т.к. 2 байта занято под выход из функции

	jsr check_end_message
	ldv 0xf3, r0
	stv r0, 0xff
	jsr check_end_message
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
		jmp ship_placement
	fi 
#достаём цифру
	pop r1 
#засовываем букву обратно в стэк
	push r0
	move r1, r0  
#Проверяем, что это цифра
	ldi r1, 48 
	ldi r2, 58 
	jsr check_correct
	if
		tst r1 
	is eq 
		pop r0 
		jsr wrong_symbols
		jmp ship_placement
	fi 
#Пушим цифру в стэк
	push r0
#Теперь в стэкэ лежат корректные буква и цифра
# буква, потом цифра/ цифра сверху типо

#############################################
	#проверяем, что сообщение закончилось выводиться в терминал
	#выводим просьбу ввести вторую координату
	ldv 0xf4, r0
	stv r0, 0xff
	jsr check_end_message
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
		jmp ship_placement
	fi 
#достаём цифру
	pop r1 
#засовываем букву обратно в стэк
	push r0
	move r1, r0  
#Проверяем, что это цифра
	ldi r1, 48 
	ldi r2, 58 
	jsr check_correct
	if
		tst r1 
	is eq 
		pop r0 
		jsr wrong_symbols
		jmp ship_placement
	fi 
#в r0 лежит 2 цифра

#в стэке так
#2 буква
#1 цифра
#1 буква
	pop r2 
	pop r1 
	push r2
	# r0 - 2 цифра / r1 - 1 цифра 
	#в стеке сверху 2 буква потом 1 буква
	if 
		cmp r1, r0 
	is eq 
	# в r1 - буква в r2 - буква
		pop r1 
		pop r2
	# в r1 разница
		sub r2, r1
	# в r3 константа для сравнения 
		ldv 0xf2, r3
		if # если разница нужная, то пытаемся поставить корабль
			cmp r3, r1 
		is eq 
			neg r1 
			add r2, r1 
			#r1 - меньшая буква
			#r2 - большая буква
			jsr test_ship_digit_const

			rts
		fi 

		neg r3

		if	
			cmp r3, r1 
		is eq 
			neg r1 
			add r2, r1 
			#r1 - большая буква
			#r2 - меньшая буква
			push r1 
			move r2, r1 
			pop r2
			#поменял местами
			#проверяем что корабль ставиться
			jsr test_ship_digit_const
			
			rts
		fi 

		jsr wrong_length
		jmp ship_placement
	fi 

	pop r2 
	pop r3 
	push r0 
	push r1 
	move r2, r0 
	move r3, r1 
#в стэке сверху 2 цифра, потом 1 цифра
# в r0 2 буква в r1 1 буква
	if 
		cmp r0, r1 
	is eq 

	#r0 - буква r1 - цифра1 r2 - цифра 2
	#достаём цифры
		pop r1 
		pop r2 
	#в r1 и r2 цифры
		sub r2, r1 
		ldv 0xf2, r3
		#в r1 лежит r2 - r1
		#в r2 какая-то цифра  
		if 
			cmp r1, r3 
		is eq 
		# если попали значит r2 - r1  = len
		# r2 > r1
			neg r1 
			add r2,r1 
			#в r1 старый ascii cod от меньшей цифры
			#в r2 ascii cod большей цифры
			jsr test_ship_figure_const


			rts 
		fi 
		neg r3 
		if 
			cmp r1, r3 
		is eq 
		# если попали значит r2 - r1  = - len
		# r1 > r2
			neg r1 
			add r2, r1 
			push r1 
			move r2, r1 
			pop r2 
			jsr test_ship_figure_const
			rts 
		fi 
		jsr wrong_length
		jmp ship_placement
	fi

	jsr wrong_coordinates
	jmp ship_placement
rts

#расставляет корабли если в координате одинаковые буквы
#r0 - буква
#r1 - меньшая цифра
#r2 - большая цифра
test_ship_figure_const:
	inc r2 
		while 
			cmp r2, r1 
		stays ne 
			push r0 
			ldi r3, -65 
			add r3, r0 
			shla r0
			move r0, r3 
			shla r3 
			shla r3 
			add r3, r0
			ldi r3, -48 
			add r1, r3 
			add r0, r3 
			ld r3, r3 

			if 
				dec r3 
			is eq 
				jsr wrong_coordinates
				jmp ship_placement
			fi 
			if 
				dec r3 
			is eq 
				jsr wrong_coordinates
				jmp ship_placement
			fi 
			pop r0 
			inc r1
		wend
		jsr load
		ldv 0xf2, r1 
		neg r1 
		add r2, r1 
		dec r1 

		while	
			cmp r1, r2 
		stays ne
			push r0 
			push r1 
			push r2 
			jsr store_ship
			pop r2 
			pop r1 
			pop r0 
			inc r1 

		wend 

rts 

#расставляет корабли если в координате одинаковые цифры
#r0 - цифра
#r1 - меньшая буква
#r2 - большая буква
test_ship_digit_const:
inc r2 
	while
		cmp r2, r1 
	stays ne 
		push r1
		ldi r3, -65
		add r3, r1
		shla r1
		move r1, r3 
		shla r3
		shla r3 
		add r3, r1  
		#в r1 умноженная на 10 координата
		ldi r3, -48 
		add r0, r3 
		add r3, r1
		ld r1, r3
		if 
			dec r3 
		is eq 
			jsr wrong_coordinates
			jmp ship_placement
		fi 
		if 
			dec r3 
		is eq 
			jsr wrong_coordinates
			jmp ship_placement
		fi 
		pop r1 
		inc r1 
	wend
	jsr load
	dec r2 
	ldv 0xf2, r1 
	neg r1  
	add r2, r1 
	inc r2 
	while 
		cmp r2, r1 
	stays ne 
		push r0 
		push r1 
		push r2 
		move r0, r3 
		move r1, r0 
		move r3, r1 
		jsr store_ship
		pop r2
		pop r1 
		pop r0
		inc r1
	wend
rts

#r0 - буква
#r1 - цифра
#функция записывает по координатам кораблик 1 на 1
#и окружает этот кораблик ! все точки в которых пусто
store_ship:
#делаем, чтобы в r0 лежала координата по y
	ldi r2, -65 
	add r2, r0
	 
#делаем, чтобы в r1 лежала координата по x
	ldi r2, -48
	add r2, r1

# в r2 ложим координату в массиве
	move r0, r3  
	shla r3 
	move r3, r2 
	shla r2 
	shla r2 
	add r3, r2 
	add r1, r2 

#загрузили в эту точку константу
#она говорит, о том что в этой точке корабль
	ldi r3, 1 
	st r2, r3

	push r2 
	
upl:
	if
		tst r0 
	is eq 
		jmp up 
	fi 
	if 
		tst r1 
	is eq 
		jmp up 
	fi


	pop r2 
	push r2 
	ldi r3, -11
	add r3, r2 
	jsr store_cell

up:
	if 
		tst r0 
	is eq 
		jmp upr
	fi 

	pop r2 
	push r2 
	ldi r3, -10
	add r3, r2 
	jsr store_cell 
upr:
	if 
		tst r0 
	is eq 
		jmp right 
	fi 

	ldi r3, 9

	if 
		cmp r3, r1
	is eq 
		jmp right 
	fi 

	pop r2 
	push r2 
	ldi r3, -9 
	add r3, r2 
	jsr store_cell
right:
	ldi r3, 9

	if 
		cmp r3, r1
	is eq 
		jmp downr
	fi 

	pop r2 
	push r2 
	ldi r3, 1 
	add r3, r2 
	jsr store_cell
downr:
	ldi r3, 9

	if 
		cmp r3, r1
	is eq 
		jmp down 
	fi

	if 
		cmp r3, r0 
	is eq 
		jmp down 
	fi 

	pop r2 
	push r2 
	ldi r3, 11 
	add r3, r2 
	jsr store_cell
down:
	ldi r3, 9
	if 
		cmp r3, r0 
	is eq 
		jmp downl 
	fi 

	pop r2 
	push r2 
	ldi r3, 10
	add r3, r2 
	jsr store_cell
downl:
	ldi r3, 9
	if 
		cmp r3, r0 
	is eq 
		jmp left 
	fi 
	if 
		tst r1 
	is eq 
		jmp left 
	fi

	pop r2 
	push r2 
	ldi r3, 9
	add r3, r2 
	jsr store_cell
left:
	if 
		tst r1 
	is eq 
		jmp the_end 
	fi
	pop r2 
	push r2 
	ldi r3, -1
	add r3, r2 
	jsr store_cell

the_end:
pop r2
rts

#r0 - буква
#r1 - цифра
#r2 - координата
store_cell: 
	#r3 содеримое по координате r2
	ld r2, r3
	if 
		dec r3
	is eq 
		jmp cont
	fi
	ldi r3, 2
	st r2, r3 
cont:
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

print_field:
	jsr pleas_wait
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
	ldi r3, 26
	
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

#####   #      #  #####     ###      ####                                 
#    #  #      #  #    #   #   #    #    #                                   
#    #  #      #  #    #  #     #   #    #                               
#####   #####  #  #####   #     #   #    #                                       
#    #  #    # #  #    #  #     #   #    #                                    
#    #  #    # #  #    #   #   #    ######                                       
#####   #####  #  #####     ###    #      #                                        

print_player_field:
	push r0
	push r1 
	ldi r0, 0xfc
	ldi r1, 0
	jsr print_field
	pop r1
	pop r0
rts

print_bot_field:
	push r0
	push r1 
	ldi r0, 0xfa
	ldi r1, 100
	jsr print_field
	pop r1
	pop r0
rts

#требует в r0 - адресс сообщения которое надо вывести
second_message:
		push r0
		ldi r0, 6
		stv r0, 0xff
		pop r0
rts

third_message:
		push r0
		ldi r0, 19
		stv r0, 0xff
		pop r0
rts

please_wait:
	push r0
	ldi r0, 72 
	stv r0, 0xff
	pop r0
rts
#функция выводит сообщение о том что введены некорректные символы
# и очищает клавиатуру
wrong_symbols: 
		push r0
		ldi r0, 84
		stv r0, 0xff
		pop r0
		jsr clean_keyboard
rts 
#функция выводит сообщение о том что введен корабль некорректной длинны
# и очищает клавиатуру
wrong_length: 
		push r0 
		ldi r0, 91
		stv r0, 0xff
		pop r0
		jsr clean_keyboard
rts 

#функция выводит сообщение о том что введены некорректные координаты
# и очищает клавиатуру
wrong_coordinates: 
		push r0 
		ldi r0, 98
		stv r0, 0xff
		pop r0
		jsr clean_keyboard
rts

#функция выводит сообщение о том что введены соседствующие координаты
#и очищает клавиатуру
naighbors_coordinates:
		push r0 
		ldi r0, 105
		stv r0, 0xff
		pop r0
		jsr clean_keyboard
rts

#корабль успешно поставлен
ship_deliver:
		push r0 
		ldi r0, 112
		stv r0, 0xff
		pop r0
rts 

#load ascii кодом
load:
		push r0 
		ldi r0, 117
		stv r0, 0xff
		pop r0
rts 

end