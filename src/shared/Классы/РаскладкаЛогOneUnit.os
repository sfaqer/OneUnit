#Использовать logos
#Использовать collectionos

// Форматирование строки, выводимой в лог (раскладка).
//
// Параметры:
//   Уровень - УровниЛога - Уровень логирования выводимого сообщения
//   Сообщение - Строка - Выводимое сообщение
//
//  Возвращаемое значение:
//   Строка - Сообщение, отформатированное с учетом раскладки
//
Функция ПолучитьФорматированноеСообщение(Знач СобытиеЛога) Экспорт

	Попытка

		Поля = Соответствия.КакКарта(СобытиеЛога.ПолучитьДополнительныеПоля());

		Возврат ПроцессорыКоллекций.ИзНабора(
			СобытиеЛога.ПолучитьСообщение(),
			Поля.ПолучитьИлиУмолчание("УровеньДерева", ""),
			Поля.ПолучитьИлиУмолчание("ИмяТеста", ""),
			Поля.ПолучитьИлиУмолчание("Результат", ""),
			Поля.Получить("ВремяВыполнения")
				.Обработать("Время -> ""("" + Время + "" мс)""")
				.Иначе_(""),
			Поля.ПолучитьИлиУмолчание("Причина", ""))
			.Фильтровать("Строка -> Не ПустаяСтрока(Строка)")
			.ВСтроку(" ");

	Исключение
		Возврат СобытиеЛога.ПолучитьСообщение();
	КонецПопытки;

КонецФункции

&Желудь
Процедура ПриСозданииОбъекта()
КонецПроцедуры
