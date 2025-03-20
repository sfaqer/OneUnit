#Использовать collectionos

Перем _ТестовыеНаборыВключаемые;
Перем _ТестовыеНаборыИсключаемые;

Функция Пропустить(Определение) Экспорт

	Результат = Ложь;

	Если ТипЗнч(Определение) <> Тип("ОпределениеТестНабора") Тогда
		Возврат Результат;
	КонецЕсли;

	Имя = Определение.Имя();

	Если Не _ТестовыеНаборыВключаемые.Пусто() Тогда

		Результат = Истина;

		Для каждого РегулярноеВыражение Из _ТестовыеНаборыВключаемые Цикл

			Если РегулярноеВыражение.Совпадает(Имя) Тогда
				Результат = Ложь;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Если Не _ТестовыеНаборыИсключаемые.Пусто() Тогда

		Для каждого РегулярноеВыражение Из _ТестовыеНаборыИсключаемые Цикл

			Если РегулярноеВыражение.Совпадает(Имя) Тогда
				Результат = Истина;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат Результат;

КонецФункции

&Фильтр
Процедура ПриСозданииОбъекта(
	&Деталька("OneUnit.ТестовыеНаборыВключаемые") ТестовыеНаборыВключаемые,
	&Деталька("OneUnit.ТестовыеНаборыИсключаемые") ТестовыеНаборыИсключаемые)

	_ТестовыеНаборыВключаемые  = Массивы.КакСписок(СтрРазделить(ТестовыеНаборыВключаемые, ",", Ложь));
	_ТестовыеНаборыИсключаемые = Массивы.КакСписок(СтрРазделить(ТестовыеНаборыИсключаемые, ",", Ложь));

	_ТестовыеНаборыВключаемые.ЗаменитьВсе("Паттерн -> Новый РегулярноеВыражение(""^"" + Паттерн + ""$"")");
	_ТестовыеНаборыИсключаемые.ЗаменитьВсе("Паттерн -> Новый РегулярноеВыражение(""^"" + Паттерн + ""$"")");

КонецПроцедуры
