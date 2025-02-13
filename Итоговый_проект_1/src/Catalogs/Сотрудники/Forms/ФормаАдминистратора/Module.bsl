
&НаКлиенте
Процедура СлучайныйПароль(Команда)
	//создать случайный пароль из символов
	СлучайныйПароль = Новый ГенераторСлучайныхЧисел;
	СимволыПароля = "1234567890_!№%:?*()-qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP{}ASDFGHJKLZXCVBNM<>@";
	КоличествоСимволов = СтрДлина(СимволыПароля);
	Пароль = "";  
	
	Для Сч = 1 по 6 цикл
		Пароль = Пароль + Сред(СимволыПароля, СлучайныйПароль.СлучайноеЧисло(1,КоличествоСимволов), 1);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПароль(Команда)
	//отключение у поля ввода «Пароль» режим пароля, чтобы пользователь увидел его и мог скопировать
	Элементы.Пароль.РежимПароля = Не Элементы.Пароль.РежимПароля 
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//ищем пользователя по УИН - получим либо УИН, либо пустой
    Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ТекущийОбъект.ИдентификаторПользователяИнформационнойБазы);
	//при записи нового сотрудника если у него вход разрешен и заполнено имя пользователя, 
	//то создаем пользователя
	Если Пользователь = Неопределено И ВходРазрешен И ЗначениеЗаполнено(ИмяДляВхода) Тогда 
		НовыйПользователь = СоздатьНовогоПользователя(ТекущийОбъект);
		
		//После создания пользователя ИБ присвоим его идентификатор реквизиту «ИдентификаторПользователяИБ» 
		//записываемого объекта, чтобы найти этого пользователя ИБ при следующем открытии формы.
		ТекущийОбъект.ИдентификаторПользователяИнформационнойБазы = НовыйПользователь.УникальныйИдентификатор;
		//смогла найти пользователя
	ИначеЕсли Пользователь <> Неопределено Тогда
        Пользователь.Имя = ИмяДляВхода;
		Пользователь.ПолноеИмя = ТекущийОбъект.Наименование; 
		Если Пароль <> "Установлен" Тогда
			//пропишем пароль
			Пользователь.Пароль = Пароль;
		КонецЕсли;   //проверить это можно только на коммерческой версии
		
		Пользователь.АутентификацияСтандартная = ВходРазрешен;  
		
		//чтобы данные которые изменили для пользователя сохранились, надо этого пользователя записать 
		//УИН не поменяется
		Пользователь.Записать();
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Функция СоздатьНовогоПользователя(Знач ТекущийОбъект)
	
	Перем НовыйПользователь;
	
	НовыйПользователь =  ПользователиИнформационнойБазы.СоздатьПользователя();
	НовыйПользователь.АутентификацияСтандартная = ВходРазрешен;
	НовыйПользователь.Имя = ИмяДляВхода;
	НовыйПользователь.ПолноеИмя = ТекущийОбъект.Наименование; 
	НовыйПользователь.Пароль = Пароль;
	НовыйПользователь.Роли.Добавить(Метаданные.Роли.БазовыеПрава);
	
	НовыйПользователь.Записать();
	Возврат НовыйПользователь;

КонецФункции

&НаСервере  
//вызывается если считываем уже записанного сотрудника
Процедура ПриЧтенииНаСервере(ТекущийОбъект) 
	//при открытии сотрудника нужно чтобы реквизиты ВходРазрешен, имя, пароль были заполнены
	
	//Найдем пользователя ИБ по идентификатору — «ТекущийОбъект.ИдентификаторПользователяИБ»
	Если ЗначениеЗаполнено(ТекущийОбъект.ИдентификаторПользователяИнформационнойБазы) Тогда
		Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ТекущийОбъект.ИдентификаторПользователяИнформационнойБазы);
		//найти по УИН может вернуть как пользователя, так и значение Неопределено	
		//Заполните по данным пользователя ИБ реквизиты формы «ИмяДляВхода» и «Пароль». 
		//Реквизит «ВходРазрешён» заполните по реквизиту пользователя ИБ «АутентификацияСтандартная»  
		Если Пользователь <> Неопределено Тогда 
			ИмяДляВхода = Пользователь.Имя; 
			//узнать заполнен пароль или нет, проверим поле
			Если Пользователь.ПарольУстановлен Тогда
				Пароль = "Установлен";  //иначе поле пустое
			КонецЕсли;
			
			//Пароль = Пользователь.Пароль;//пароль считывать нельзя будет ошибка - поле объекта недоступно для чтения
			ВходРазрешен = Пользователь.АутентификацияСтандартная;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
