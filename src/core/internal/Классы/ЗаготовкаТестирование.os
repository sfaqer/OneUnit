#Использовать collectionos
#Использовать decorator
#Использовать "../../../shared"

Перем _КаталогиТестов;
Перем _ФайлыТестов;
Перем _ИскатьВПодкаталогах;

Процедура ПриИнициализацииПоделки(Поделка) Экспорт

	ПутиКТестовымНаборам = Новый КартаСоответствие();
	Поделка.ДобавитьЗавязь(
		"&Завязь(""ПутиКТестовымНаборам"", Тип = ""КартаСоответствие"") () ->
		|	Возврат ПутиКТестовымНаборам;",
		Новый Структура("ПутиКТестовымНаборам", ПутиКТестовымНаборам)
	);

	ФайлыТестов = ТестированиеСлужебный.РазвернутьСписокТестовыхНаборов(
		_КаталогиТестов,
		_ФайлыТестов,
		_ИскатьВПодкаталогах
	);

	Для каждого Тест Из ФайлыТестов Цикл

		Путь          = Тест.ПолноеИмя;
		ТестовыйНабор = "oneunit_testcase_" + Тест.ИмяБезРасширения;

		ДобавитьЗавязь = Ложь;

		Попытка

			ПодключитьСценарий(Путь, ТестовыйНабор);

			Если Не ЕстьКонструктор(Путь) Тогда
				ДобавитьЗавязь = Истина;
			КонецЕсли;

		Исключение

			Ошибка = Новый ИнформацияОбОшибке(
				СтрШаблон(
					"Ошибка подключения тестового набора %1
					|%2",
					Путь,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				),
				ИнформацияОбОшибке()
			);

			ПостроительДекоратора = Новый ПостроительДекоратора()
				.Поле(Новый Поле("Ошибка").ЗначениеПоУмолчанию(Ошибка))
				.Метод(Новый Метод("ПередВсеми")
					.Аннотация(Новый Аннотация("ПередВсеми"))
					.ТелоМетода("ВызватьИсключение Ошибка;")
					.Публичный()
					.ЭтоПроцедура());

			ПостроительДекоратора.ЗарегистрироватьВСистемеТипов(ТестовыйНабор);

			ДобавитьЗавязь = Истина;

		КонецПопытки;

		Если ДобавитьЗавязь Тогда

			Поделка.ДобавитьЗавязь(СтрШаблон(
				"&ТестовыйНабор &Завязь(""%1"", Тип = ""%1"") () -> 
				|	Возврат Новый %1;
				|",
				ТестовыйНабор
			));

		КонецЕсли;

		ПутиКТестовымНаборам.Вставить(ТестовыйНабор, СтрЗаменить(Путь, ТекущийКаталог(), "."));

	КонецЦикла;

КонецПроцедуры

Функция ЕстьКонструктор(Путь)

	ЧтениеТекста = Новый ЧтениеТекста(Путь, КодировкаТекста.UTF8);
	ТекстСценария = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	ЕстьКонструктор = СтрНайти(ТекстСценария, "Процедура ПриСозданииОбъекта") > 0
		Или СтрНайти(ТекстСценария, "Procedure OnObjectCreation") > 0;

	Возврат ЕстьКонструктор;

КонецФункции

&Заготовка
Процедура ПриСозданииОбъекта(
	&Деталька("OneUnit.КаталогиТестов") КаталогиТестов,
	&Деталька("OneUnit.ФайлыТестов") ФайлыТестов,
	&Деталька("OneUnit.ИскатьВПодкаталогах", ЗначениеПоУмолчанию = Ложь) ИскатьВПодкаталогах)

	_КаталогиТестов       = СтрРазделить(КаталогиТестов, ",", Ложь);
	_ИскатьВПодкаталогах  = ИскатьВПодкаталогах;
	_ФайлыТестов          = СтрРазделить(ФайлыТестов, ",", Ложь);

КонецПроцедуры
