#Использовать 1commands
#Использовать tempfiles
#Использовать collectionos
#Использовать "../internal"

&ОпцияКаталогиТестов
Перем КаталогиТестов;

&ОпцияИскатьВПодкаталогах
Перем ИскатьВПодкаталогах;

&ОпцияФайлыТестов
Перем ФайлыТестов;

&ОпцияТегиВключаемые
Перем ТегиВключаемые;

&ОпцияТегиИсключаемые
Перем ТегиИсключаемые;

&ОпцияТестовыеНаборыВключаемые
Перем ТестовыеНаборыВключаемые;

&ОпцияТестовыеНаборыИсключаемые
Перем ТестовыеНаборыИсключаемые;

&ОпцияТестовыеМетодыВключаемые
Перем ТестовыеМетодыВключаемые;

&ОпцияТестовыеМетодыИсключаемые
Перем ТестовыеМетодыИсключаемые;

&ОпцияРежимВывода
Перем РежимВывода;

Перем _Лог;
Перем _ЛогДляКомандыМенеджера;

&ВыполнениеКоманды
Процедура Обнаружить() Экспорт

	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов();
	МенеджерВременныхФайлов.БазовыйКаталог = МенеджерВременныхФайлов.СоздатьКаталог();

	Детальки = Новый Соответствие();

	Детальки.Вставить("КаталогиТестов",            КаталогиТестов);
	Детальки.Вставить("ФайлыТестов",               ФайлыТестов);
	Детальки.Вставить("ИскатьВПодкаталогах",       ИскатьВПодкаталогах);
	Детальки.Вставить("ТегиВключаемые",            ТегиВключаемые);
	Детальки.Вставить("ТегиИсключаемые",           ТегиИсключаемые);
	Детальки.Вставить("ТестовыеНаборыВключаемые",  ТестовыеНаборыВключаемые);
	Детальки.Вставить("ТестовыеНаборыИсключаемые", ТестовыеНаборыИсключаемые);
	Детальки.Вставить("ТестовыеМетодыВключаемые",  ТестовыеМетодыВключаемые);
	Детальки.Вставить("ТестовыеМетодыИсключаемые", ТестовыеМетодыИсключаемые);

	Если КонсольноеПриложениеТестированиеСлужебный.РежимВыводаЛога(РежимВывода) = РежимыВыводаЛога.Дерево Тогда
		Репортер = "Поделка.НайтиЖелудь(""РепортерЛогДерево"").ВывестиТестПлан(ТестПлан);";
	ИначеЕсли КонсольноеПриложениеТестированиеСлужебный.РежимВыводаЛога(РежимВывода) = РежимыВыводаЛога.ПлоскийСписок Тогда
		Репортер = "Поделка.НайтиЖелудь(""РепортерЛогПлоскийСписок"").ВывестиТестПлан(ТестПлан);";
	Иначе
		Репортер = "";
	КонецЕсли;

	ИмяВременногоФайла = КонсольноеПриложениеТестированиеСлужебный.СоздатьТочкуВхода(
		Детальки,
		МенеджерВременныхФайлов,
		_Лог,
		СтрШаблон(
			"ТестПлан = МенеджерТестирования.Обнаружить();
			|%1
			|",
			Репортер
		)
	);

	Команда = Новый Команда;

	Команда.УстановитьКоманду("oscript");
	Команда.ДобавитьПараметр(ИмяВременногоФайла);
	Команда.ДобавитьЛогВыводаКоманды(_ЛогДляКомандыМенеджера);

	КодВозврата = Команда.Исполнить();

	МенеджерВременныхФайлов.Удалить();

	Если КодВозврата <> 0 Тогда
		Сообщить("Обнаружение завершилось неудачно", СтатусСообщения.ОченьВажное);
		ЗавершитьРаботу(КодВозврата);
	КонецЕсли;

КонецПроцедуры

&КомандаПриложения(Имя = "discover d", Описание = "Выводит в консоль все обнаруженные тесты")
Процедура ПриСозданииОбъекта(
	&Лог("oscript.lib.oneunit.cli") Лог,
	&Пластилин ЛогДляКомандыМенеджера)

	_Лог                    = Лог;
	_ЛогДляКомандыМенеджера = ЛогДляКомандыМенеджера;

КонецПроцедуры
