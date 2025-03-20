#Использовать 1commands
#Использовать tempfiles
#Использовать collectionos
#Использовать coverage
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

&Опция(Имя = "timeout", Описание = "Время ожидания выполнения каждого теста по умолчанию (в миллисекундах)")
&ТЧисло
&ПоУмолчанию(0)
Перем Таймаут;

&Опция(Имя = "junit", Описание = "Путь к файлу отчета в формате JUnit")
&ТСтрока
// &ПоУмолчанию("out/tests/junit.xml")
Перем ПутьКОтчетуJUnit;

&Опция(Имя = "genericExecution", Описание = "Путь к файлу отчета в формате GenericExecution")
&ТСтрока
// &ПоУмолчанию("out/tests/genericExecution.xml")
Перем ПутьКОтчетуGenericExecution;

&Опция(Имя = "openTestReport", Описание = "Путь к файлу отчета в формате OpenTestReport")
&ТСтрока
// &ПоУмолчанию("out/tests/openTestReport.xml")
Перем ПутьКОтчетуOpenTestReport;

&Опция(Имя = "genericCoverage", Описание = "Путь к файлу отчета покрытия в формате GenericCoverage")
// &ПоУмолчанию("out/coverage/coverage.xml")
Перем ПутьКОтчетуПокрытияВФорматеGenericCoverage;

&Опция(Имя = "cobertura", Описание = "Путь к файлу отчета покрытия в формате Cobertura")
// &ПоУмолчанию("out/coverage/cobertura.xml")
Перем ПутьКОтчетуПокрытияВФорматеCobertura;

&ОпцияРежимВывода
Перем РежимВывода;

Перем _Лог;
Перем _ЛогДляКомандыМенеджера;

&ВыполнениеКоманды
Процедура Тестировать() Экспорт

	ФормироватьПокрытие = Не ПустаяСтрока(ПутьКОтчетуПокрытияВФорматеGenericCoverage)
		ИЛИ Не ПустаяСтрока(ПутьКОтчетуПокрытияВФорматеCobertura);

	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов();
	МенеджерВременныхФайлов.БазовыйКаталог = МенеджерВременныхФайлов.СоздатьКаталог();

	Списки.ИзЭлементов(ПутьКОтчетуGenericExecution, ПутьКОтчетуJUnit, ПутьКОтчетуOpenTestReport)
		.ПроцессорКоллекции()
		.Фильтровать("(Путь) -> Не ПустаяСтрока(Путь)")
		.ДляКаждого("(Путь) -> ФС.ОбеспечитьКаталог(Новый Файл(Путь).Путь);");

	Детальки = Новый Соответствие();

	Детальки.Вставить("КаталогиТестов",              КаталогиТестов);
	Детальки.Вставить("ФайлыТестов",                 ФайлыТестов);
	Детальки.Вставить("ИскатьВПодкаталогах",         ИскатьВПодкаталогах);
	Детальки.Вставить("Таймаут",                     Таймаут);
	Детальки.Вставить("ПутьКОтчетуJUnit",            ПутьКОтчетуJUnit);
	Детальки.Вставить("ПутьКОтчетуGenericExecution", ПутьКОтчетуGenericExecution);
	Детальки.Вставить("ПутьКОтчетуOpenTestReport",   ПутьКОтчетуOpenTestReport);
	Детальки.Вставить("ТегиВключаемые",              ТегиВключаемые);
	Детальки.Вставить("ТегиИсключаемые",             ТегиИсключаемые);
	Детальки.Вставить("ТестовыеНаборыВключаемые",    ТестовыеНаборыВключаемые);
	Детальки.Вставить("ТестовыеНаборыИсключаемые",   ТестовыеНаборыИсключаемые);
	Детальки.Вставить("ТестовыеМетодыВключаемые",    ТестовыеМетодыВключаемые);
	Детальки.Вставить("ТестовыеМетодыИсключаемые",   ТестовыеМетодыИсключаемые);

	Детальки.Вставить("РежимВыводаЛога", КонсольноеПриложениеТестированиеСлужебный.РежимВыводаЛога(РежимВывода));

	ИмяВременногоФайла = КонсольноеПриложениеТестированиеСлужебный.СоздатьТочкуВхода(
		Детальки,
		МенеджерВременныхФайлов,
		_Лог,
		"
		|	ТестПлан = МенеджерТестирования.Тестировать();
		|	Статистика = Поделка.НайтиЖелудь(""РепортерСтатистика"")
		|		.СтатистикаТестПлана();
		|
		|	Если Статистика.ПолучитьИлиУмолчание(""НаборовОшибка"", 0) > 0
		|		Или Статистика.ПолучитьИлиУмолчание(""ТестовОшибка"", 0) > 0 Тогда
		|		ЗавершитьРаботу(1);
		|	КонецЕсли;
		|
		|"
	);

	ПутьКСтатистике = МенеджерВременныхФайлов.НовоеИмяФайла("json");

	Команда = Новый Команда;

	Команда.УстановитьКоманду("oscript");

	Если ФормироватьПокрытие Тогда
		Команда.ДобавитьПараметр("-codestat=" + ПутьКСтатистике);
	КонецЕсли;

	Команда.ДобавитьПараметр(ИмяВременногоФайла);

	Команда.УстановитьИсполнениеЧерезКомандыСистемы(Ложь);

	Команда.ДобавитьЛогВыводаКоманды(_ЛогДляКомандыМенеджера);

	КодВозврата = Команда.Исполнить();

	Если ФормироватьПокрытие Тогда

		ВременныйКаталог = МенеджерВременныхФайлов.НовоеИмяФайла();

		ФС.ОбеспечитьПустойКаталог(ВременныйКаталог);

		ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

		ПроцессорГенерации.ФайлСтатистики(ПутьКСтатистике)
			.РабочийКаталог(ВременныйКаталог)
			.GenericCoverage("genericCoverage.xml")
			.Cobertura("cobertura.xml")
			.Сформировать();

		Если Не ПустаяСтрока(ПутьКОтчетуПокрытияВФорматеCobertura) Тогда
			ФС.ОбеспечитьКаталог(Новый Файл(ПутьКОтчетуПокрытияВФорматеCobertura).Путь);
			КопироватьФайл(ОбъединитьПути(ВременныйКаталог, "cobertura.xml"), ПутьКОтчетуПокрытияВФорматеCobertura);
		КонецЕсли;

		Если Не ПустаяСтрока(ПутьКОтчетуПокрытияВФорматеGenericCoverage) Тогда
			ФС.ОбеспечитьКаталог(Новый Файл(ПутьКОтчетуПокрытияВФорматеGenericCoverage).Путь);
			КопироватьФайл(ОбъединитьПути(ВременныйКаталог, "genericCoverage.xml"), ПутьКОтчетуПокрытияВФорматеGenericCoverage);
		КонецЕсли;

	КонецЕсли;

	МенеджерВременныхФайлов.Удалить();

	Если КодВозврата <> 0 Тогда
		Сообщить("Тестирование завершилось неудачно", СтатусСообщения.ОченьВажное);
		ЗавершитьРаботу(КодВозврата);
	Иначе
		Сообщить("Тестирование завершилось удачно", СтатусСообщения.Информация);
	КонецЕсли;

КонецПроцедуры

&КомандаПриложения(Имя = "execute e", Описание = "Тестирует проект")
Процедура ПриСозданииОбъекта(
	&Лог("oscript.lib.oneunit.cli") Лог,
	&Пластилин ЛогДляКомандыМенеджера)

	_Лог                    = Лог;
	_ЛогДляКомандыМенеджера = ЛогДляКомандыМенеджера;

КонецПроцедуры
