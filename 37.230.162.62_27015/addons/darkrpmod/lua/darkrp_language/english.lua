/*---------------------------------------------------------------------------
English (example) language file
---------------------------------------------------------------------------

This is the english language file. The things on the left side of the equals sign are the things you should leave alone
The parts between the quotes are the parts you should translate. You can also copy this file and create a new language.

= Warning =
Sometimes when DarkRP is updated, new phrases are added.
If you don't translate these phrases to your language, it will use the English sentence.
To fix this, join your server, open your console and enter darkp_getphrases yourlanguage
For English the command would be:
	darkrp_getphrases "en"
because "en" is the language code for English.

You can copy the missing phrases to this file and translate them.

= Note =
Make sure the language code is right at the bottom of this file

= Using a language =
Make sure the convar gmod_language is set to your language code. You can do that in a server CFG file.
---------------------------------------------------------------------------*/

local my_language = {
	-- Admin things
	need_admin = "Вам нужны права админа для %s",
	need_sadmin = "Вам нужны права суперадмина для %s",
	no_privilege = "У вас нет нужных прав для этого действия",
	no_jail_pos = "Позиция тюрьмы не установлена",
	invalid_x = "Ошибка в %s! %s",

	-- F1 menu
	f1ChatCommandTitle = "Чат-команды",
	f1Search = "Поиск...",

	-- Money things:
	price = "Цена: %s%d",
	priceTag = "Цена: %s",
	reset_money = "%s сбросил деньги всем игрокам!",
	has_given = "%s дал вам %s",
	you_gave = "Вы дали %s %s",
	npc_killpay = "%s за убийство НИПа!",
	profit = " дохода",
	loss = "убыток",

	-- backwards compatibility
	deducted_x = "Вычтено %s%d",
	need_x = "Нужно %s%d",

	deducted_money = "Вычтено %s",
	need_money = "Нужно %s",

	payday_message = "Зарплата! Вы получили %s!",
	payday_unemployed = "Вы безработный и вы не получаете зарплату!",
	payday_missed = "Получка пропущена! (Вы под арестом)",

	property_tax = "Налог на собственность! %s",
	property_tax_cant_afford = "Вы не смогли уплатить налоги! Ваша собственность отобрана у вас!",
	taxday = "День налогов! Вычтено %s%% из вашей прибыли!",

	found_cheque = "Вы нашли %s%s в чеке, выписанном вам от %s.",
	cheque_details = "Этот чек выписан %s.",
	cheque_torn = "Вы разорвали чек.",
	cheque_pay = "Уплата: %s",
	signed = "Подпись: %s",

	found_cash = "Вы нашли %s%d!", -- backwards compatibility
	found_money = "Вы нашли %s!",

	owner_poor = "Владелец %s слишком беден чтобы субсидировать эту продажу!",

	-- Police
	Wanted_text = "Разыскивается!",
	he_wanted = "Разыскивается полицией!\nПричина: %s",
	youre_arrested = "Вы были арестованы на %d секунд!",
	youre_arrested_by = "%s арестовал вас.",
	youre_unarrested_by = "%s выпустил вас.",
	hes_arrested = "%s был арестован на %d секунд!",
	hes_unarrested = "%s был выпущен из тюрьмы!",
	warrant_ordered = "%s приказывает обыскать %s. Причина: %s",
	warrant_request = "%s запрашивает ордер на обыск %s. Причина: %s",
	warrant_request2 = "Запрос на ордер отправлен %s!",
	warrant_approved = "Запрос на обыск %s был одобрен!\nПричина: %s\nПриказ выдал: %s",
	warrant_approved2 = "Теперь вы можете обыскать его дом.",
	warrant_denied = "%s отклонил ваш запрос на ордер.",
	warrant_expired = "Ордер на обыск %s истёк!",
	warrant_required = "Вам нужен ордер на обыск чтобы взломать эту дверь.",
	warrant_required_unfreeze = "Вам нужен ордер на обыск чтобы разморозить этот проп.",
	warrant_required_unweld = "Вам нужен ордер на обыск чтобы отсоединить этот проп.",
	wanted_by_police = "%s разыскивается полицией!\nПричина: %s\nПриказ выдал: %s",
	wanted_by_police_print = "%s объявил %s в розыск, причина: %s",
	wanted_expired = "%s больше не разыскивается полицией.",
	wanted_revoked = "%s больше не разыскивается полицией.\nОтменил: %s",
	cant_arrest_other_cp = "Вы не можете арестовывать других копов!",
	must_be_wanted_for_arrest = "Игрок должен быть в розыске чтобы вы могли арестовать его.",
	cant_arrest_fadmin_jailed = "You cannot arrest a player who has been jailed by an admin.",
	cant_arrest_no_jail_pos = "Вы не можете арестовывать людей так как нет позиций для тюрьмы!",
	cant_arrest_spawning_players = "Вы не можете арестовывать людей которые спавнятся.",
	escape_from_jail = "побег из тюрьмы",

	suspect_doesnt_exist = "Подозреваемый отсутствует.",
	actor_doesnt_exist = "Действующее лицо отсутствует.",
	get_a_warrant = "Запросить ордер на обыск",
	give_warrant = "Выдать ордер на обыск гражданина",
	make_someone_wanted = "Объявить в розыск",
	remove_wanted_status = "Снять розыск",
	already_a_warrant = "Ордер на обыск подозреваемого всё ещё в силе.",
	already_wanted = "Подозреваемый уже в розыске.",
	not_wanted = "Подозреваемый не в розыске.",
	need_to_be_cp = "Вы должны быть представителем полиции.",
	suspect_must_be_alive_to_do_x = "Подозреваемый должен быть живым чтобы %s.",
	suspect_already_arrested = "Подозреваемый уже в тюрьме.",

	-- Mayor
	curfew = "Объявлен комендантский час: ",


	-- Players
	health = "Здоровье: %s",
	job = "Работа: %s",
	salary = "Зарплата: %s%s",
	wallet = "Кошелёк: %s%s",
	weapon = "Оружие: %s",
	kills = "Убийств: %s",
	deaths = "Смертей: %s",
	rpname_changed = "%s сменил ролевое имя на %s",
	disconnected_player = "Отсоединившийся игрок",
	hunger = "Голод: ",
	starving = "ГОЛОДАНИЕ",
	armor = "Броня: ",
	in_jail = "В тюрьме",
	with_license = "Имеется лицензия",
	radio_disabled = "Рация отключена",
	wanted = "В розыске: ",

	-- Cars
	path = "Путь: ",
	m = "%d м",
	km = "%d км",
	speed = "Скорость: ",
	kmh = "%d км/ч",

	-- Teams
	need_to_be_before = "Вы должны быть %s чтобы стать %s",
	need_to_make_vote = "Вы должны провести голосование чтобы стать %s!",
	team_limit_reached = "Нельзя стать %s, лимит исчерпан",
	wants_to_be = "%s желает стать %s",
	has_not_been_made_team = "%s не стал %s!",
	job_has_become = "%s стал %s!",

	-- Keys, vehicles and doors
	keys_allowed_to_coown = "Вам разрешено быть со-владельцем\n(Нажмите F2 чтобы стать со-владельцем)\n",
	keys_other_allowed = "Потенциальные со-владельцы:",
	keys_allow_ownership = "(Нажмите F2 чтобы разрешить владение)",
	keys_disallow_ownership = "(Нажмите F2 чтобы запретить владение)",
	keys_owned_by = "Владелец:",
	keys_unowned = "Свободно\n(Нажмите F2 чтобы стать владельцем)",
	keys_everyone = "(Нажмите F2 чтобы разрешить для всех)",
	door_unown_arrested = "You can not own or unown things while arrested!",
	door_unownable = "This door cannot be owned or unowned!",
	door_sold = "Вы продали это помещение за %s",
	door_already_owned = "Этим помещением уже кто-то владеет!",
	door_cannot_afford = "Недостаточно средств для покупки этого помещения!",
	door_hobo_unable = "Вы не можете купить помещение если вы бомж!",
	vehicle_cannot_afford = "Вы не можете позволить себе этот транспорт!",
	door_bought = "Вы купили это помещение за %s%s",
	vehicle_bought = "Вы купили этот транспорт за %s%s",
	door_need_to_own = "Вам нужно владеть этой дверью чтобы %s",
	door_rem_owners_unownable = "Вы не можете удалять владельцев если дверь неовладима!",
	door_add_owners_unownable = "Вы не можете добавлять владельцев если дверь неовладима!",
	rp_addowner_already_owns_door = "%s уже (со-)владеет этой дверью!",
	add_owner = "Добавить владельца",
	remove_owner = "Удалить владельца",
	coown_x = "Со-владение %s",
	allow_ownership = "Разрешить владение",
	disallow_ownership = "Запретить владение",
	edit_door_group = "Редактировать группу двери",
	door_groups = "Группы дверей",
	door_group_doesnt_exist = "Группа дверей не существует!",
	door_group_set = "Группа двери успешно установлена.",
	sold_x_doors_for_y = "Вы продали %d дверей за %s%d!", -- backwards compatibility
	sold_x_doors = "Вы продали %d дверей за %s!",
	too_short = "Слишком короткий.",
	too_long = "Слишком длинный",

	-- Entities
	gmod_camera = "Камера",
	gmod_tool = "Тулган",
	weapon_bugbait = "Комок грязи",
	weapon_physcannon = "Гравипушка",
	weapon_physgun = "Физган",

	drugs = "Наркотики",
	drug_lab = "Лаборатория наркотиков",
	gun_lab = "Лаборатория оружия",
	gun = "Пушка",
	microwave = "Микроволновка",
	food = "Еда [Голод | ХП]",
	money_printer = "Денежный принтер",

	write_letter = "Написать письмо...",
	send = "Отправить",
	sign_this_letter = "Подписать это письмо",
	signed_yours = "С уважением,",

	money_printer_exploded = "Ваш денежный принтер взорвался!",
	money_printer_reward = "Вы получили",
	money_printer_overheating = "Ваш денежный принтер перегревается!",

	previous_owner_nof = "Прежний: ",
	microwave_steal = "Нажми здесь чтобы украсть",
	microwave_hacking = "Перепрошивание...",
	microwave_alreadyown = "Вы уже владеете этой мирковолновкой!",
	microwave_alert = "Вашу микроволновку крадут!",

	camera_destroyed = "Ваша камера уничтожена!",

	contents = "Содержит: ",
	amount = "Количество: ",

	picking_lock = "Взламываем замок",

	cannot_pocket_x = "Вы не можете положить это в сумку!",
	object_too_heavy = "Этот предмет слишком тяжёлый.",
	pocket_full = "Ваша сумка полна!",
	pocket_no_items = "Ваша сумка пуста.",
	drop_item = "Выбросить предмет",

	bonus_destroying_entity = "уничтожение нелегального предмета.",

	switched_burst = "Переключение на пакетный режим огня.",
	switched_fully_auto = "Переключение на автоматический режим огня.",
	switched_semi_auto = "Переключение на полуавтоматический режим огня.",

	keypad_checker_shoot_keypad = "Shoot a keypad to see what it controls.",
	keypad_checker_shoot_entity = "Shoot an entity to see which keypads are connected to it",
	keypad_checker_click_to_clear = "Right click to clear.",
	keypad_checker_entering_right_pass = "Entering the right password",
	keypad_checker_entering_wrong_pass = "Entering the wrong password",
	keypad_checker_after_right_pass = "after having entered the right password",
	keypad_checker_after_wrong_pass = "after having entered the wrong password",
	keypad_checker_right_pass_entered = "Right password entered",
	keypad_checker_wrong_pass_entered = "Wrong password entered",
	keypad_checker_controls_x_entities = "This keypad controls %d entities",
	keypad_checker_controlled_by_x_keypads = "This entity is controlled by %d keypads",
	keypad_on = "ON",
	keypad_off = "OFF",
	seconds = "seconds",

	persons_weapons = "Нелегальное оружие в руках у %s:",
	returned_persons_weapons = "Вернул вещи конфискованные у %s.",
	no_weapons_confiscated = "%s не имеет конфискованных предметов!",
	no_illegal_weapons = "%s не имеет нелегального оружия.",
	confiscated_these_weapons = "Конфисковал следующее оружие:",
	checking_weapons = "Проверяем оружие",

	shipment_antispam_wait = "Подождите прежде чем спавнить другой ящик.",
	shipment_cannot_split = "Нельзя разделить этот ящик.",

	-- Talking
	hear_noone = "Никто не слышит ваш%s!",
	hear_everyone = "Вас все слышат!",
	hear_certain_persons = "Ваш%s слышат: ",

	whisper = "шёпот",
	yell = "крик",
	advert = "[Реклама]",
	broadcast = "[Вещание]",
	radio = "радио",
	request = "(ЗАПРОС!)",
	group = "(группе)",
	demote = "(УВОЛЬНЕНИЕ)",
	ooc = "OOC",
	radio_x = "Радио %d",

	request_willyou = "Гражданин %s вызывает полицию с причиной:\n%s\nОповестить его о том, что вы приедете?",
	request_hewill = "%s %s выехал на ваш вызов",

	talk = " чат",
	speak = " голос",

	speak_in_ooc = " чат в OOC",
	perform_your_action = "е выполнение действия",
	talk_to_your_group = "е сообщение группе",

	channel_set_to_x = "Канал установлен на %s!",

	-- Notifies
	disabled = "%s выключено! %s",
	gm_spawnvehicle = "The spawning of vehicles",
	gm_spawnsent = "The spawning of scripted entities (SENTs)",
	gm_spawnnpc = "The spawning of Non-Player Characters (NPCs)",
	see_settings = "Please see the DarkRP settings.",
	limit = "Вы достигли лимита %s!",
	have_to_wait = "Вам нужно подождать ещё %d секунд прежде чем %s!",
	must_be_looking_at = "Вам нужно смотреть на %s!",
	incorrect_job = "Неправильная работа для %s",
	unavailable = "%s недоступен",
	unable = "Вы не можете %s. %s",
	cant_afford = "Вы не можете позволить себе %s",
	created_x = "%s создал %s",
	cleaned_up = "Ваши %s были очищены.",
	you_bought_x = "Вы купили %s за %s%d.", -- backwards compatibility
	you_bought = "Вы купили %s за %s.",
	you_received_x = "Вы получили %s за %s.",

	created_first_jailpos = "You have created the first jail position!",
	added_jailpos = "You have added one extra jail position!",
	reset_add_jailpos = "You have removed all jail positions and you have added a new one here.",
	created_spawnpos = "%s's spawn position created.",
	updated_spawnpos = "%s's spawn position updated.",
	do_not_own_ent = "Вы не владеете этим предметом!",
	cannot_drop_weapon = "Нельзя выбросить это оружие!",
	job_switch = "Профессии были успешно обменены!",
	job_switch_question = "Поменяться профессиями с %s?",
	job_switch_requested = "Запрос об обмене профессиями отправлен.",

	cooks_only = "Только поварам.",

	-- Misc
	unknown = "Неизвестное",
	arguments = "аргументы",
	no_one = "никто",
	door = "двери",
	vehicle = "транспорт",
	door_or_vehicle = "дверь/транспорт",
	driver = "Занято: %s",
	name = "Название %s",
	lock = "Закрыть",
	locked = "Закрыто",
	unlock = "Открыть",
	unlocked = "Открыто",
	player_doesnt_exist = "Игрок отсутствует.",
	job_doesnt_exist = "Профессия не существует!",
	must_be_alive_to_do_x = "Вы должны быть живы чтобы %s.",
	banned_or_demoted = "Забанен/уволен",
	wait_with_that = "Эй, подожди с этим.",
	could_not_find = "Невозможно найти %s",
	f3tovote = "Нажмите F3 или зажмите TAB чтобы вывести курсор для голосования",
	listen_up = "Внимание:", -- In rp_tell or rp_tellall
	nlr = "Правило новой жизни (NLR): Не убивайте/арестовывайте в отместку.",
	reset_settings = "Все настройки сброшены!",
	must_be_x = "Вы должны быть %s чтобы сделать %s.",
	agenda_updated = "Повестка дня обновлена",
	job_set = "%s сменил свою работу на '%s'",
	demoted = "%s был уволен",
	demoted_not = "%s не был уволен",
	demoted_not_quorum = "%s не был уволен (не набрался кворум)",
	demote_vote_started = "%s запустил голосование об увольнении %s",
	demote_vote_text = "Причина увольнения:\n%s", -- '%s' is the reason here
	cant_demote_self = "Вы не можете уволить себя же.",
	i_want_to_demote_you = "Я желаю уволить тебя с работы. Причина: %s",
	tried_to_avoid_demotion = "Вы попытались избежать увольнения. Хорошая попытка, но вы всё равно были уволены.", -- naughty boy!
	lockdown_started = "Объявлен комендантский час, возвращайтесь по домам!\n",
	lockdown_ended = "Комендатский час отменён",
	gunlicense_requested = "%s запросил лицензию у %s",
	gunlicense_granted = "%s дал %s лицензию",
	gunlicense_denied = "%s отказал %s в лицензии",
	gunlicense_question_text = "Дать %s лицензию?",
	gunlicense_remove_vote_text = "%s начал голосование об отзыве лицензии у %s",
	gunlicense_remove_vote_text2 = "Отозвать лицензию:\n%s", -- Where %s is the reason
	gunlicense_removed = "Лицензия %s не была отозвана!",
	gunlicense_not_removed = "Лицензия %s была отозвана!",
	vote_specify_reason = "Вам нужно указать причину!",
	vote_started = "Голосование создано",
	vote_alone = "Вы выиграли голосование так как вы один на сервере.",
	you_cannot_vote = "Вы не можете голосовать!",
	x_cancelled_vote = "%s cancelled the last vote.",
	cant_cancel_vote = "Could not cancel the last vote as there was no last vote to cancel!",
	jail_punishment = "Наказание за отсоединение! Арестован на: %d секунд.",
	admin_only = "Админам только!", -- When doing /addjailpos
	chief_or = "Шефам или ", -- When doing /addjailpos
	frozen = "Заморожено.",
	yes_demote = "Да, уволить",
	no_demote = "Нет, не увольнять",
	dont_vote = "Не голосовать",

	dead_in_jail = "Вы мертвы до тех пор, пока с вас не снимут арест!",
	died_in_jail = "%s умер в тюрьме!",

	credits_for = "АВТОРЫ %s\n",
	credits_see_console = "Список авторов DarkRP отправлен в консоль.",

	rp_getvehicles = "Available vehicles for custom vehicles:",

	data_not_loaded_one = "Ваши данные ещё не загрузились. Пожалуйста, подождите.",
	data_not_loaded_two = "Если проблема все ещё остаётся, свяжитесь с админом.",

	cant_spawn_weapons = "Вы не можете спавнить оружие.",
	drive_disabled = "Управление отключено.",
	property_disabled = "Опция отключена.",

	not_allowed_to_purchase = "Вам нельзя купить этот предмет.",

	rp_teamban_hint = "rp_teamban [player name/ID] [team name/id]. Use this to ban a player from a certain team.",
	rp_teamunban_hint = "rp_teamunban [player name/ID] [team name/id]. Use this to unban a player from a certain team.",
	x_teambanned_y = "%s забанил %s с профессии %s.",
	x_teamunbanned_y = "%s разбанил %s с профессии %s.",

	-- Backwards compatibility:
	you_set_x_salary_to_y = "Вы установили зарплату %s в %s%d.",
	x_set_your_salary_to_y = "%s установил вам зарплату в %s%d.",
	you_set_x_money_to_y = "Вы установили количество денег %s в %s%d.",
	x_set_your_money_to_y = "%s установил вам количество денег в %s%d.",

	you_set_x_salary = "Вы установили зарплату %s в %s.",
	x_set_your_salary = "%s установил вам зарплату в %s.",
	you_set_x_money = "Вы установили количество денег %s в %s.",
	x_set_your_money = "%s установил вам количество денег в %s.",
	you_set_x_name = "Вы установили %s имя %s",
	x_set_your_name = "%s установил вам имя %s",

	someone_stole_steam_name = "Someone is already using your Steam name as their RP name so we gave you a '1' after your name.", -- Uh oh
	already_taken = "Уже занято.",

	job_doesnt_require_vote_currently = "Эта профессия не требует голосования на данный момент!",

	x_made_you_a_y = "%s сделал вас %s!",

	cmd_cant_be_run_server_console = "This command cannot be run from the server console.",

	-- The lottery
	lottery_started = "Проводится лотерея! Участвовать за %s%d?", -- backwards compatibility
	lottery_has_started = "Проводится лотерея! Участвовать за %s?",
	lottery_entered = "Вы участвуете в лотерее за %s",
	lottery_not_entered = "%s не участвует в лотерее",
	lottery_noone_entered = "Никто не участвовал в лотерее",
	lottery_won = "%s выиграл %s в лотерее!",

	-- Animations
	custom_animation = "",
	bow = "Поклон",
	sexy_dance = "Танец 1",
	dance = "Танец 2",
	zombie = "Зомби",
	salute = "Отдать честь",
	forward = "Вперед",
	follow_me = "За мной",
	laugh = "Смех",
	lion_pose = "Лев",
	nonverbal_no = "Нет",
	thumbs_up = "Палец вверх",
	wave = "Помахать",
	cheer = "Радость",
	robot = "Робот",

	-- AFK
	afk_mode = "AFK Mode",
	salary_frozen = "Your salary has been frozen.",
	salary_restored = "Welcome back, your salary has now been restored.",
	no_auto_demote = "You will not be auto-demoted.",
	youre_afk_demoted = "You were demoted for being AFK for too long. Next time use /afk.",
	hes_afk_demoted = "%s has been demoted for being AFK for too long.",
	afk_cmd_to_exit = "Type /afk again to exit AFK mode.",
	player_now_afk = "%s is now AFK.",
	player_no_longer_afk = "%s is no longer AFK.",

	-- Hitmenu
	hit = "заказ",
	hitman = "Заказной убийца",
	current_hit = "Заказ: %s",
	cannot_request_hit = "Невозможно сделать заказ! %s",
	hitmenu_request = "Заказать",
	player_not_hitman = "Этот игрок не убийца по заказу!",
	distance_too_big = "Слишком большое расстояние.",
	hitman_no_suicide = "Убийца не может убить себя.",
	hitman_no_self_order = "Убийца не может получить заказ от себя же.",
	hitman_already_has_hit = "Убийца уже имеет заказ.",
	price_too_low = "Цена слишком низкая!",
	hit_target_recently_killed_by_hit = "Цель была ранее убита по заказу,",
	customer_recently_bought_hit = "Заказчик сделал заказ ранее.",
	accept_hit_question = "Принять заказ от %s\nв отношении %s за %s%d?", -- backwards compatibility
	accept_hit_request = "Принять заказ от %s\nв отношении %s for %s?",
	hit_requested = "Заказ сделан!",
	hit_aborted = "Заказ прерван! %s",
	hit_accepted = "Заказ принят!",
	hit_declined = "Убийца отклонил заказ!",
	hitman_left_server = "Убийца покинул сервер!",
	customer_left_server = "Заказчик покинул сервер!",
	target_left_server = "Цель покинула сервер!",
	hit_price_set_to_x = "Цена на заказ установлена в %s%d.", -- backwards compatibility
	hit_price_set = "Цена на заказ установлена в %s.",
	hit_complete = "Заказ у %s выполнен!",
	hitman_died = "Заказной убийца умер!",
	target_died = "Цель умерла!",
	hitman_arrested = "Заказной убийца был арестован!",
	hitman_changed_team = "Заказной убийца сменил команду!",
	x_had_hit_ordered_by_y = "%s имел действующий заказ от %s",

	-- Vote Restrictions
	hobos_no_rights = "Бездомные не имеют права голоса!",
	gangsters_cant_vote_for_government = "Бандиты не могут голосовать по правительственным делам!",
	government_cant_vote_for_gangsters = "Представители правительства не могут голосовать по делам криминалов!",

	-- VGUI and some more doors/vehicles
	vote = "Голосование",
	time = "Время: %d",
	yes = "Да",
	no = "Нет",
	ok = "Окей",
	cancel = "Отмена",
	add = "Добавить",
	remove = "Удалить",
	none = "Ничего",
	none_alt = "нет",
	confirmed = "Подтверждено",

	x_options = "Опции %s",
	sell_x = "Продать %s",
	set_x_title = "Задать название %s",
	set_x_title_long = "Задать название %s на которую вы смотрите.",
	jobs = "Профессии",
	buy_x = "Купить %s",

	-- F4menu
	no_extra_weapons = "Эта должность не даёт дополнительного оружия.",
	become_job = "Занять должность",
	create_vote_for_job = "Создать голосование",
	shipments = "Ящики",
	F4guns = "Оружие",
	F4entities = "Предметы",
	F4ammo = "Патроны",
	F4vehicles = "Транспорт",
	F4donate = "Донат и Премиум",
	F4attachments = "Оптика и снаряжение",

	-- Tab 1
	give_money = "Передать деньги",
	drop_money = "Выбросить пачку денег",
	change_name = "Сменить ролевое имя",
	go_to_sleep = "Уснуть или проснуться",
	drop_weapon = "Выбросить текущее оружие",
	customize_weapon = "Настроить текущее оружие",
	buy_health = "Купить излечение за %s",
	request_gunlicense = "Запросить лицензию на оружие",
	demote_player_menu = "Уволить игрока с работы",


	searchwarrantbutton = "Объявить в розыск",
	unwarrantbutton = "Снять розыск",
	noone_available = "Никто не доступен",
	request_warrant = "Запросить ордер на обыск",
	make_wanted = "Объявить кого-либо в розыск",
	make_unwanted = "Снять розыск с кого-либо",
	set_jailpos = "Установить позицию тюрьмы (сброс)",
	add_jailpos = "Добавить позицию тюрьмы",

	set_custom_job = "Установить название профессии",

	set_agenda = "Установить агенду",

	initiate_lockdown = "Установить комендантский час",
	stop_lockdown = "Отменить комендантский час",
	start_lottery = "Запустить лотерею",
	give_license_lookingat = "Дать лицензию",

	laws_of_the_land = "ЗАКОНЫ ГОРОДА",
	law_added = "Закон добавлен.",
	law_removed = "Закон удалён.",
	law_reset = "Законы сброшены.",
	law_too_short = "Текст закона слишком короткий.",
	laws_full = "Доска законов переполнена.",
	default_law_change_denied = "Вам не разрешено менять основные законы.",

	-- Second tab
	job_name = "Название: ",
	job_description = "Описание: ",
	job_weapons = "Оружие: ",

	-- Entities tab
	buy_a = "Купить %s: %s",

	-- Licenseweaponstab
	license_tab = [[License weapons

	Tick the weapons people should be able to get WITHOUT a license!
	]],
	license_tab_other_weapons = "Other weapons:",

	-- Destroyer
	destroyer_message = "Принесите сюда денежный принтер, наркотики или оружие чтобы получить награду.",
	destroyer_reward = "Награда за уничтожение нелегального предмета: $%d!",
	destroyer_bringthis = "Отнесите это в уничтожитель в полицейском участке чтобы получить награду.",

	-- Car Terminal
	car_terminal = "Автотерминал",

	-- Printer
	printer_disabled = "Принтер отключен. Отнесите его в уничтожитель в полицейском участке чтобы получить награду.",
	printer_fixed = "Полицейская блокировка снята. Принтер снова функционирует.",
	printer_warning = "Внимание!\nНеосторожное обращение приведёт к возгоранию!",
	printer_speed = "Скорость",
	printer_speed_upgrade = "апгрейд скорости",
	printer_rely = "Надёжность",
	printer_rely_upgrade = "апгрейд надёжности",
	printer_start = "Начать печать",
	printer_auto = "Автоповтор",
	printer_update = "Обновить за %s",

	-- Jobs
	citizens = "Граждане",
	law_enforcement = "Правопорядок",
	criminal = "Криминал",
	criminal_business = "Криминальный бизнес",
	city_service = "Городские службы",
	business = "Бизнес",

	citizen = "Гражданин",
	citizen_desc = [[Гражданин — базовый общественный слой, которым вы можете безпрепятственно стать. У вас нет предопределенной роли в жизни города. Вы можете придумать себе свою собственную профессию и заниматься вашим делом.]],
	hobo = "Бездомный",
	hobo_desc = [[Бездомный находится в самом низу общественного строя. Над ним все смеются.
		У вас нет дома.
		Вы вынуждены просить еду и деньги.
		Постройте дом из дощечек и мусора, чтобы укрыться от холода.
		Вы можете поставить ведро и написать на нём просьбу, чтобы вам подавали денег.
		Проявите фантазию, устройте цирковое представление, спойте. Таким образом вы можете получить больше денег.]],
	fishman = "Рыбак",
	fishman_desc = [[Используйте свои умения для добычи улова на продажу. Покупайте снасти и улучшайте свою удочку чтобы получать больше и больше улова.

	Нажмите B, держа удочку, чтобы открыть меню.]],
	cp = "Офицер Полиции",
	cp_desc = [[Полицейский является защитником каждого гражданина, который живет в городе.
		У вас есть власть, вы можете арестовать преступников и защитить невинных людей.
		Бейте их StunStick'ом, если преступники ослушались вас.
		Battering Ram (Таран) может выломать дверь любого игрока, но только с ордером на обыск.
		Таран также может выбивать замороженные пропы игрока.
		Используйте C-меню для использования возможностей офицера.]],
	cp_msg_pos = "Вам нужно быть в Полицейском Участке (ПУ), чтобы стать полицейским!",
	cp_msg_wanted = "Нельзя становиться полицейским в розыске!",
	chief = "Убер-офицер Полиции",
	chief_desc = [[Убер-офицер Полиции является главным среди полицейских.
		Координируйте действия сотрудников Полиции, наводя порядок в городе.
		Бейте непослушных STUNSTICK'ом.
		Battering Ram (Таран) может выломать дверь любого игрока, но только с ордером на обыск.
		Таран также может выбивать замороженные пропы игрока.
		Используйте C-меню для использования возможностей убер-офицера.]],
	mayor = "Глава города",
	mayor_desc = [[Мэр города создает законы, чтобы улучшить жизнь людей в городе.
	Если вы мэр, то вы можете создавать или принимать ордера на обыск игроков.
	Используйте C-меню для использования возможностей мэра.
	Во время Комендантского часа все люди должны быть в своих домах, а полицейские должны патрулировать город.]],
	gangster = "Бандит",
	gangster_desc = [[Низшая каста в криминальном мире.
		Бандит обычно работает на главу банды, который заправляет всеми делами.
		Воруйте, убивайте на заказ и следуйте агенде от босса, или вы, возможно, будете наказаны.]],
	mobboss = "Глава банды",
	mobboss_desc = [[Глава банды является самым главным преступником в городе.
	Он даёт задания своим подчинённым бандитам и формирует эффективные преступные группировки.
	Он обладает способностью взламывать квартиры и выпускать из тюрем людей.]],
	mobboss_msg = "Станьте бандитом и создайте свою банду (C-меню) чтобы получить эту профессию.",
	merc = "Наёмник",
	merc_desc = [[Наемник выполняет различные заказы за определенную плату. Заказы могут быть какими угодно: убийство, кража, разведка и любые другие. Покупать услуги наемника могут как бандиты, так и полиция и другие граждане.]],
	medic = "Медик",
	medic_desc = [[Доктор способен исцелить игроков с помощью своих медицинских знаний.
	Используйте аптечку чтобы лечить себя или других, либо продавайте аптечки покупателям.]],
	gundealer = "Продавец оружия",
	gundealer_desc = [[Продавец оружия является единственным человеком, который может легально продавать оружие другим людям.
		Удостовертесь в том, что вы не продаёте нелегальные виды вооружения в открытую, иначе вас могут арестовать!]],
	trader = "Торговец",
	trader_desc = [[Продавайте различные полезные приспособления (отмычки, раздатчики и др.).
	Перекупайте вещи, оружие. Откройте магазин и начните продажу товаров.]],
	bar = "Бармен",
	bar_desc = [[Повар - это большая ответственность, нужно накормить всех людей вашего города.
	Вы можете купить микроволновую печь и продавать еду. Для этого напишите /Buymicrowave, чтобы изменить цену напишите в чате /price <цена>, также вы можете покупать гамбургеры, молоко и другую еду.
	Вам предстоит открыть свой бар и принимать клиентов. Вы также можете продавать продукты, если кто придёт к вам с пустым желудком.
	Также наймите обязательно охрану от буйных посетителей.]],
	carmaster = "Автомастер",
	carmaster_desc = [[Чините и заправляйте машины.]],
	security = "Охранник",
	security_desc = [[Нанимайтесь в охрану магазина, банка или телохранителем.
	Вы должны защищать заведение от хулиганов и мелких воров.
	При сложной ситуации вызывайте полицию.
	По умолчанию вам даётся Stunstick, так что не рискуйте особо, действуйте осторожно.]],
	taxidriver = "Таксист",
	taxidriver_desc = [[Подвозите людей на машине и зарабатывайте на этом деньги.]],
	fireman = "Пожарный",
	fireman_desc = [[Ответственная и очень опасная работа. Без вас город может просто сгореть до тла.
	За тушение пожаров вы получаете вознаграждение.]],

	extinguish_fire = "%s за тушение огня!",
	extinguish_prop = "%s за тушение пропы!",
	extinguish_player = "%s за тушение человека!",
	extinguish_vehicle = "%s за тушение транспорта!",

	-- Weapons
	wep_nx_c4 = "Бомба C4",
	nx_c4_ammo = "Бомба",
	lockpick = "Отмычка",
	weapon_extinguisher = "Огнетушитель",
	nx_radio = "Рация",
	nx_fuel = "Канистра бензина",
	fuel_ammo = "Бензин",
	fas2_ifak = "Пехотная аптечка",
	stunstick = "\"Демократизатор\"",
	fas2_dv2 = "Боевой нож DV2",
	fas2_machete = "Мачете",
	fas2_ots33 = "ОЦ-33 «Пернач»",
	weapon_rpg = "Противотраспортная ракетница",
	fas2_m67 = "Граната M67",
	molotov = "Коктейль Молотова",

	-- Ammo
	ammo = "Патроны",
	RPG_Round = "Ракета RPG",
	bandages = "Бинты",
	hemostats = "Зажимы",
	quikclots = "Пластыри",

	-- Categories
	devices = "Оборудование",
	other = "Другое",
	pistols = "Пистолеты",
	smg = "Пистолет-пулемёты",
	rifles = "Винтовки",
	sniper_rifles = "Снайперские винтовки",
	shotguns = "Дробовики",

	-- Attachments
	sights = "Прицел %s",
	tritium_sights = "Тритиевый Прицел",
	foregrip = "Рукоятка",
	bipod = "Бипод",
	silencer = "Глушитель",
	clip = "Магазин %s",

	-- Entities
	piano = "Рояль",
	wepdetector = "Детектор оружия",
	turret = "Турель",
	playxradio = "Радио PlayX",
	playxtv = "Телевизор PlayX",
	playxbillboard = "Биллборд PlayX",
	charger_medkit = "Раздатчик здоровья",
	charger_suit = "Раздатчик брони",
	radar = "Радар",

	-- Drugs
	beer = "Пиво",
	cigarettes = "Сигареты",
	weed = "Марихуана",

	-- SWEPs
	keys = "Ключи",
	pocket = "Сумка",
	arrest_stick = "Арестовывающая дубинка",
	weaponchecker = "Проверка на оружие",
	nx_speedmeter = "Радар-измеритель",
	deployable_tool = "Распаковщик",
	nx_repair = "Починка машины",

	-- Hints
	bomb_instructions1 = "ЛКМ - Выбросить бомбу",
	bomb_instructions2 = "ПКМ - Прикрепить бомбу к стене",

	unpacker_instructions1 = "Установить предмет: ",
	unpacker_instructions2 = "Повернуть предмет: ",
	unpacker_instructions3 = "Отменить: ",
	unpacker_instructions4 = "Зажмите %s после распаковки,",
	unpacker_instructions5 = "чтобы упаковать обратно",

	respawn_timer = "До возрождения осталось %d секунд",
	respawn_fee = "Вы заплатили %s за медицинские услуги",
	premium_only = "Доступно только для владельцев Премиум",

	hitman_use = "Нажмите E чтобы заказать убийство",

	rules = "Правила",
	read_rules = "Обязательно ознакомтесь с правилами, нажав ",
	nobind = "[НЕ НАЗНАЧЕНО]",

	-- Cars
	car_on_fire = "Ваша машина горит, эвакуация невозможна",
	car_bought = "Машина куплена",
	car_buymsg = "Вы приобрели %s.\nИспользуйте ближайший терминал чтобы заспавнить машину.",
	car_rentmsg = "Вы арендовали %s.\nИспользуйте ближайший терминал чтобы заспавнить машину.",
	car_nomoney = "У вас недостаточно денег",
	car_modified = "Машина изменена",
	car_sold = "Машина продана",
	car_hobos = "У бездомных нет машин",
	car_coplimit = "Достигнут лимит полицейских машин",
	car_stolen = "Ваша машина украдена",
	car_spawned = "Машина вызвана",
	dead_cant = "Мертвые не могут",
	arrested_cant = "Арестованные не могут",
	car_removed = "Машина убрана",
	car_request = "Пустить %s в машину?",
	car_request_sent = "Запрос отправлен",
	car_request_sent_already = "Запрос уже отправлен",
	car_ok_but_distance = "Водитель одобрил запрос, но вы уже слишком далеко от машины",
	car_ok_but_distance_owner = "Пассажир уже слишком далеко от машины",
	car_retrieved = "Владение машиной восстановлено",
	car_alarm = "Сигнализация!",
	car_lockpick_success = "Машина украдена!",
	need_warrant = "Нужен ордер",
	car_rent_broken = "Машина повреждена, почините её у Автомастера",
	car_rent_end = "Аренда машины прекращена",
	car_rent_premium = "Вызов арендованной машины доступен только Премиумам.",
	car_rent_need_premium = "Для аренды машины вам нужен Премиум, который можно найти в разделе Подписки.",
	car_rent_limit = "У вас уже есть арендованная машина!",
	car_rent_start = "Машина арендована",
	car_rent_stop = "Прекратить аренду",
	car_rent_stop_ask = "Сдать машину обратно?",

	my_cars = "Мои машины",
	buy = "Купить",
	car_spawn = "Вызвать",
	car_modify = "Изменить",
	car_sell_for = "Продать: ",
	sell_x_for_x = "Продать %s за %s?",
	modify_x_for_x = "Изменить %s за %s?",
	car_sell = "Продать машину",
	car_modification = "Изменение машины",
	car_apply = "Применить: ",
	car_driver = "Занято:",
	car_passenger = "Пассажир %d:",
	car = "Машина",
	car_kick = "Выгнать",
	previous_owner = "Прежний владелец: %s",
	taxi_popup = "Такси €%d/километр",
	car_retrieval = "Возвращение машины",

	-- Laws
	laws_title = "Законы города",
	laws_speedlimit = "Ограничение скорости для транспортных средств: ",
	laws_kmh = " км/ч",
	laws_legal = "Легальное",
	laws_license = "Требуется лицензия",
	laws_illegal = "Нелегальное",
	close = "Закрыть",
	apply = "Применить",
	laws_added = "Глава города добавил закон ",
	laws_edited = "Глава города отредактировал закон ",
	laws_removed = "Глава города удалил закон ",
	laws_set = "Установлены законы ",
	laws_clear = "Глава города очистил законы.",
	laws_reset = "Глава города сбросил законы.",
	laws_default = "Установлены стандартные законы.",

	-- City Management
	cc_cityman = "Управление городом",
	cc_copman = "Управление полицией",
	cc_laws = "Законы",
	cc_limits = "Ограничения",
	cc_orders = "Указы",
	cc_upgrades = "Улучшения",
	cc_points = "Очки власти: ",
	cc_save = "<Enter> - сохранить изменения",
	cc_lawlength = "Длина закона должна быть 3 - 1000",
	cc_resetlaws = "Сбросить законы на стандартные",
	cc_clearlaws = "Очистить законы",
	cc_addlaw = "Добавить закон",
	cc_lawlimit = "Достигнут лимит законов",
	cc_lawtext = "Текст закона",
	cc_invitecop = "Сделать полицейским",
	cc_kickcop = "Выгнать из полиции",
	cc_assignchief = "Назначить убер-офицера",

	-- City Management SV
	cc_limitschanged = "Глава города изменил ограничения.",
	cc_invitetext = "%s приглашает вступить в полицию",
	cc_invited = "Глава города пригласил %s в полицию.",
	cc_nopoints = "Недостаточно очков власти",
	cc_kicked = "Глава города освободил %s от должности.",
	cc_chiefassigned = "Глава города назначил %s убер-офицером.",
	cc_upgradedalready = "Улучшение уже приобретено",
	cc_upgraded = "Улучшение '%s' приобретено",
	cc_mayor_upgraded = "%s приобрел улучшение '%s'",

	lockdown_reason = "Причина: %s",
	door_cp = "Правоохранительные органы",
	agenda_cp = "Повестка дня полиции",

	police_halo = "Радар полиции",
	gang_halo = "Радар банды",
	door_upgrade = "Улучшенные двери",

	charger_medkit_desc = "В здании полиции появляется раздатчик здоровья.",
	charger_suit_desc = "В здании полиции появляется раздатчик брони.",
	door_upgrade_desc = "Государственные двери получают сенсорные панели для удобного открытия/закрытия с отображением статуса замка.",
	police_halo_desc = "Союзников видно через стены зеленым цветом. Если союзник говорит в рацию, цвет сменится на синий. Если союзник получает урон, цвет сменится на красный.",
	microwave_desc = "В здании полиции появляется микроволновка.",
	radio_desc = "Все бандиты в банде автоматически получают рацию.",

	-- CMenu
	issue_cheque = "Выписать чек",
	buy_current_ammo = "Купить патроны на текущее оружие",
	call_to = "Позвонить",
	call_emergency = "Вызвать 911",
	police = "Полиция",
	police_call = "Вызвать полицию",
	ambulance = "Скорая помощь",
	ambulance_call = "Вызвать скорую помощь",
	fire_service = "Пожарная служба",
	call_fire_service = "Вызвать пожарную службу",
	describe_problem = "Опишите происшествие",
	phone_off = "Отключить телефон",
	phone_on = "Включить телефон",
	phone_is_off = "Телефон отключен",
	phone_is_on = "Телефон включен",
	send_location = "Показать свое местоположение",
	option_gang = "- Банда -",
	location_sent = "Местоположение отправлено",
	call_taxi = "Вызвать такси",
	write_letter = "Написать письмо",
	show_laws = "Свод законов",
	upgrades = "Улучшения",
	roll_the_dice = "Бросить кубик",
	roll_sides = "Количество сторон",
	demote_warn = "Используйте увольнение только когда вы стопроцентно уверенны в своей правоте.\nНекорректное использование увольнений грозит баном.\n\nВведите причину:",
	sell_all_doors = "Продать все двери",
	enter_new_title = "Введите новое название",
	edit_model = "Настроить модель",
	remove_car = "Убрать машину",
	turret_control = "Управление турелями",
	set_shop_pos = "Установить позицию магазина",
	shop_pos_set = "Позиция для обнаружения торговцев установлена",
	microwave_setprice = "Установить цену на микроволновку",
	taxi_setprice = "Установить цену за километр",
	enter_price = "Введите цену",
	enter_reason = "Введите причину",
	stop_dna_scan = "Остановить сканирование ДНК",
	enter_entry_cost = "Введите стоимость участия",
	select_radio_channel = "Сменить канал рации",
	radio_off = "Отключить рацию",
	radio_on = "Включить рацию",

	create_group = "Создать банду",
	manage_group = "Управление бандой",
	leave_group = "Покинуть банду",
	enter_summ = "Введите сумму",
	unarrest_player = "Освободить из заключения",
	split_shipment = "Разделить ящик поровну",
	make_shipment = "Сделать ящик из оружия",
	pack = "Упаковать",

	cmenu_hint = "Вы можете открыть игровое меню, зажав кнопку C",
	hint = "Подсказка",

	-- bomb
	bomb_code = "Код:",
	timer_until = "До взрыва (секунд):",
	start_timer = "Запустить отсчет",
	take_bomb = "Забрать бомбу",
	stop_timer = "Остановить отсчет",
	wrong_code = "Неверный код",
	letter_code = "Код бомбы: ",

	-- weplocker
	pwl_title = "Оружейный шкаф полиции",
	pwl_count = "Взято полицейских оружий: ",
	pwl_warn = "Вы не сможете брать оружия, если нанесете урон другому полицейскому.",
	pwl_wep = "Оружие",
	pwl_avail_c = "Доступность",
	pwl_taken = "занято",
	pwl_avail = "доступно",
	pwl_unavail = "не доступно",
	pwl_giveme = "Получить выбранное оружие",
	pwl_timer = "До следующей выдачи: ",
	pwl_return = "Сдать полученное оружие",
	pwl_close = "Закрыть шкаф",

	pwl_fail_team = "Брать оружие из оружейного шкафа может только полиция.",
	pwl_fail_damage = "Вы не можете брать оружие так как наносили урон другому полицейскому.",
	pwl_fail_already = "У вас уже есть оружие из шкафа.",
	pwl_fail_taken = "Это оружие уже взято другим полицейским.",
	pwl_fail_limit = "Достигнут лимит оружий из шкафа.",
	pwl_wait = "Подождите %d секунд.",
	pwl_success = "Оружие выдано.",
	pwl_returned = "Оружие возвращено.",

	--
	radar_already = "У вас уже есть радар.",
	c4_defuser = "Набор для обезвреживания",

	unpacker_packed = "Предмет возвращён в коробку",
	unpacker_toofar = "Слишком далеко от коробки",

	radio_instructions1 = "Зажмите [%s], чтобы говорить в рацию",
	radio_instructions2 = "Само по себе доставание рации ничего не делает",
	radio_instructions3 = "и нужно только для возможности выбросить рацию",

	repair_paid = "Цена ремонта: ",

	speedmeter_instructions = "ЛКМ - приказать водителю остановиться",
	speedmeter_stopnow = "Сотрудник ДПС приказывает остановиться",
	speedmeter_ordered_x = "Водителю %s приказано остановиться",
	speedmeter_ordered = "Водителю приказано остановиться",

	wepcheck_legal = "Легальное: ",
	wepcheck_illegal = "Нелегальное: ",
	wepcheck_noweps = " не имеет оружия.",
	money_printers_genitive = "денежных принтеров",
	cantpocket_printer = "Нельзя положить принтер в сумку!",

	-- Food
	burger = "Чизбургер",
	hotdog = "Хот-дог",
	watermelon = "Арбуз",
	soda = "Содовая",
	milk = "Молоко",
	orange = "Апельсин",
	water_bottle = "Бутылка воды",
	difm_station = "Станция",
	difm_silence = "- Тишина 24/7 -",
	difm_volume = "Громкость",

	--
	car_hint_coplight = "Нажмите Shift+R чтобы включить или выключить мигалки",
	car_hint_taxiprice = "Вы можете изменить цену поездки за километр через /taxiprice",

	-- Taxi
	taxi_nomoney = "У вас больше нет денег на оплату дальнейшего пути!",
	taxi_paid = "Уплачено €%d за поездку на такси",
	taxi_payment = "Получено €%d за поездку",
	taxi_setprice_fail = "Нельзя менять цену во время поездки!",
	taxi_setprice_ok = "Цена €%d за километр установлена",
	taxi_nocar = "Вам нужно обладать машиной такси!",
	call_taxi_fail = "К сожалению, сейчас нет ни одного таксиста.",
	call_taxi_alert = "Вызов такси!",

	--
	demote_restriced = "Голосование на увольнение могут запустить только премиумы и администраторы",
	fishingmod_you = "[fishingmod] Вы ",
	fishingmod_spent = "потратили",
	fishingmod_received = "получили",

	--
	coolmodel_enabled = "Заменять стандартные модели",
	coolmodel_skin = "Скин:",
	coolmodel_respawn = "Изменения вступят в силу после респавна.",
	coolmodel_nopremium = "У вас нет Премиума, настраиваемые\nмодели не будут работать.",
	coolmodel_none = "Отсутствует",
	coolmodel_settings = "Настройка",
	coolmodel_color = "Цвет",
	coolmodel_title = "Настройка модели",

	--
	rpname_fail = "2 части (имя и фамилия) минимум",
	he_wants_demote = "%s (%s) желает уволить %s (%s):\n%s",
	he_wants_demote_vgui = "желает уволить",
	he_wants_demote_vgui_res = "с причиной:",
	wanna_vote_demote = "%s (%s) желает уволить %s (%s):\n%s\nЖелаете голосовать?",
	pm_fail = "Используйте команду !pm или вкладку PM в чате.",
	precache_panic = "Из-за ограничений Source Engine, на которые мы не можем повлиять,\nсервер будет перезагружен через %d секунд или ранее.\nВ противном случае сервер бы просто упал.\nКупленные вещи, профессия и местоположение будут возвращены автоматически.",
	restartstuff_given = "Вам возвращено %s за вещи, которые были у вас в момент отключения сервера.",
	arrest_reason = "Причина ареста",
	arrested_x = "Арестованный ",

	-- Detective
	dna_crush = "удар тяжелым предметом",
	dna_bullet = "пулевое ранение",
	dna_fall = "падение с высоты",
	dna_blast = "взрыв",
	dna_club = "удар твердым предметом",
	dna_drown = "утопание",
	dna_slash = "ранение холодным оружием",
	dna_burn = "огонь",
	dna_vehicle = "ДТП",
	dna_unknown = "неизвестно",
	dna_title = "Убитый",
	dna_name = "Имя убитого: ",
	dna_job = "Профессия убитого: ",
	dna_time = "Время смерти: %d секунд назад",
	dna_reason = "Причина смерти: ",
	dna_dist = "Расстояние до убийцы: ",
	dna_weapon = "Орудие убийства: ",
	dna_nopoint = "Убийца уже был убит или арестован",
	dna_destroyed = "ДНК уничтожено предыдущими пробами",
	dna_start = "Начать сканирование ДНК убийцы",
	dna_decoy = "Образец ДНК распался",
	dna_timeout = "Тело исчезнет через %d секунд.",
	dna_call = "Вызвать полицию",
	dna_call_done = "Полиция вызвана",
	dna_cr = "Здесь убитый %s!",
	dna_scanner = "Сканер ДНК",
	dna_scan_name = "Убитый: ",
	dna_searching = "Ищем убийцу",
	dna_next = "До следующего сканирования: ",
	dna_decoy_time = "ДНК распадется через ",
	dna_killer = "Убивший %s",
	dna_killer_dead = "Убийца мертв",
	dna_arrest = "Арест совершен по результату экспертизы ДНК",
	dna_killer_arrested = "Убийца арестован",
	dna_killer_leave = "Убийца покинул город",

	--
	arrest_question = "Арестован %s\nДа - указать причину ареста\nНет - отпустить из тюрьмы\nАрестованный будет отпущен автоматически, если причина не будет указана",
	hitletter = "Заказ на убийство %s от %s.",

	--
	mayor_overthrown = "Глава города был свержен!",
	mayor_danger = "Глава города в опасности! Если его убьют в течение 5 минут, он потеряет должность.",
	mayor_nodanger = "Глава города больше не в опасности.",

	-- Group
	gang_creation = "Создание банды",
	gang_name = "Название банды:",
	gang_info = "В банде должно быть хотя бы 2 бандита.",
	gang_create = "Создать банду",
	gang_poor_name = "Бездарное название",
	gang_few_mates = "Выбрано слишком мало бандитов",
	gang_tab_bandits = "Бандиты",
	gang_kick = "Изгнать",
	gang_invite = "Пригласить в банду",
	gang_give = "Выдать деньги банде",
	gang_give_title = "Выдача денег банде",
	gang_split = "Разделить на всех",
	gang_each = "Каждому",
	gang_split_am = "Количество € (разделить на всех):",
	gang_each_am = "Количество € (каждому):",
	gang_request = "Запросить деньги у банды",
	gang_request_title = "Запрос денег у банды",
	gang_request_am = "Количество € (с каждого):",
	gang_disband = "Распустить группу",
	gang_disband_title = "Роспуск группы",
	gang_disband_confirm = "Подтвердите роспуск группы",
	gang_invite_title = "Приглашение в банду",
	gang_send_invites = "Разослать приглашения",

	-- Gang SV
	gang_disbanded = "Банда %s (босс: %s) распущена",
	gang_job_leaderonly = "Менять это может только лидер банды",
	gang_job_nocopy = "Не должно сожержать названий других банд",
	gang_name_copy = "Банда с таким именем уже существует",
	gang_mates_fail = "Бандиты не выбраны, вышли с сервера или не соответствуют",
	gang_accepted = " принял приглашение в банду",
	gang_created = "Банда создана",
	gang_he_created = "%s создал банду %s",
	gang_not_accepted = " не принял приглашение в банду",
	gang_not_created = "Банда не создана",
	gang_invites_sent = "Приглашения разосланы",
	gang_upgrade_bought = "Глава банды приобрел улучшение %s",
	gang_invite_text = "Вы хотите вступить в %s (глава: %s)?",
	gang_invite_msg = " приглашает вас в банду ",
	gang_kicked_you = " выгнал вас из банды ",
	gang_kicked = " изгнан из банды",
	gang_job_changed_you = " сменил ваш ранг на ",
	gang_job_changed = "Ранг %s изменен на %s",
	gang_given_each = "Выдано %s каждому",
	gang_gave_you = " выдал вам ",
	gang_request_sent = "Запросы разосланы",
	gang_request_text = "Глава группы запрашивает %s",
	gang_he_gave = " передал ",
	gang_he_left = " покинул банду",
	gang_boss = "Глава ",

	-- Markers
	marker_sent_you = " показал вам свое местоположение",
	marker_no_police = "К сожалению, сейчас нет ни одного полицейского",
	marker_no_fire = "К сожалению, сейчас нет ни одного пожарного",
	marker_no_medic = "К сожалению, сейчас нет ни одного медика",

	-- Permaupgrades
	up_flashlight = "Фонарь",
	up_flashlight_desc = "Нажмите F (impulse 100), чтобы включить фонарь.",
	up_door_upgrade = "Улучшенные Двери",
	up_door_upgrade_desc = "Все купленные вами двери получают сенсорную панель для удобного открытия/закрытия.",
	up_parkour = "Паркур",
	up_parkour_desc = "1 уровень: возможность один раз прыгнуть от стены.\n2 уровень: возможность хвататься за уступы.",
	up_level = " (уровень ",
	up_bought = "Куплено",
	up_already = "Это улучшение у вас уже есть",
	up_bought_msg = "Приобретено улучшение ",
	up_nomoney = "Недостаточно денег",

	-- Phone/Radio
	phone = "Телефон",
	phone_call_out = "Исходящий вызов",
	phone_call_in = "Входящий вызов",
	phone_drop = "Сброс",
	phone_answer = "Принять",
	phone_dismiss = "Отклонить",
	phone_already = "Звонок уже активен",
	phone_busy = ": занято",
	phone_remote_off = ": аппарат абонента отключен или находится вне зоны действия сети",
	phone_noans = ": нет ответа",

	radio_title = "Рация: выбор канала",
	radio_group_chan = "Канал группы",
	radio_group_chan_ok = "Выбран групповой канал рации",
	radio_chan = "Канал (1-999):",
	radio_chan_ok = "Выбран канал рации ",
	radio_chan_fail = "Канал должен быть числом 1-999.",

	--
	sec = " с",
	tradersell_who = "Кто станет владельцем?",
	ifak_nomoney = "Вы не получите денег за лечение игрока, которому вы наносили урон",
	dice_roll = "%s кидает кубик (%d). Выпало число %d.",

	rpname_info = "Выберите себе ролевое имя.\nВаше ролевое имя должно быть реалистичным (никаких Котов Барсиков), не содержать лишних знаков пунктуации и соблюдать правильность использования регистра букв.",
	rpname_name = "Имя",
	rpname_surname = "Фамилия",

	premium = "Премиум",
	connecting = "Подключается",
	score_ingame = " человек в игре",
	score_and = " и ",
	score_connecting = " подключаются",

	elevator_title = "ЛИФТ",
	elevator_hall = "Зал",
	elevator_office = "Офисы",

	deployable_onlylast = "Распаковать ящик может только последний державший",
	deployable_wait = "Подождите %d секунд",

	--
	warn_cops = "Сообщить в полицию",
	cr_phrase = "Здесь разыскиваемый %s!",

	widget_rules = "Правила",
	widget_news = "Новости",
	widget_info = "Помощь",
	widget_group = "Группа Steam",

	-- elections
	elections_timer = "Выборы с %d кандидатами через %s",

	quota = "Квота: %d%% от текущих игроков",
	no_quota = "Нет квоты",
	quota_notice = "Лимиты на профессиях зависят от количества игроков\nИгроки с Премиум подпиской могут занимать профессии в обход лимитов",

	enemy = "Враг",
	neutral = "Нейтрал",
	friend = "Друг",
	turret_default = "По умолчанию:",
	turret_friends = "Друзья:",
	steam_friends = "Друзья Steam",
	gang_or_police = "банда / полиция",
	cant_pack_turret = "Нельзя упаковать сломанную турель",
	turret_already_repair = "Турель уже чинится",
	turret_repairing = "Ремонт начался",
	turret_attacked = "Турель атакована!",
	turret_lockpicker = "Взломщик!",
	turret_owner = "Владелец: ",

	-- Player stats
	stat_stamina_low = "Изнеможден",
	stat_stamina_med = "Устал",
	stat_stamina_hi = "Утомился",

	stat_break_low = "Ушиб",
	stat_break_med = "Вывих",
	stat_break_hi = "Перелом",

	stat_starve_low = "Проголодался",
	stat_starve_med = "Голоден",
	stat_starve_hi = "Смертельно голоден",

	stat_drowning = "Недостаточно кислорода",

	stat_bleed_low = "Кровотечение",
	stat_bleed_med = "Сильное кровотечение",
	stat_bleed_hi = "Смертельная потеря крови",

	stat_bone_left_quadricep = "Левая бедренная кость",
	stat_bone_left_knee = "Левая коленная чашечка",
	stat_bone_left_shin = "Левая малоберцовая кость",
	stat_bone_left_ankle = "Левая таранная кость",
	stat_bone_left_foot = "Левая ступня",
	stat_bone_left_toe = "Левая лодыжка",

	stat_bone_right_quadricep = "Правая бедренная кость",
	stat_bone_right_knee = "Правая коленная чашечка",
	stat_bone_right_shin = "Правая малоберцовая кость",
	stat_bone_right_ankle = "Правая таранная кость",
	stat_bone_right_foot = "Правая ступня",
	stat_bone_right_toe = "Правая лодыжка",

	nx_medcenter = "Медкит",
	nx_medcenter_energy = "Батарея медкита",
	medcenter_mode_heal = "Общее лечение",
	medcenter_mode_bones = "Рентген",
	medcenter_mode_desease = "Общий анализ",
	medcenter_skel_health = "Целостность скелета",
	medcenter_skel_scanning = "Сканирование",
	medcenter_health = "Здоровье",
	medcenter_ready = "Готов",

}
-- The language code is usually (but not always) a two-letter code. The default language is "en".
-- Other examples are "nl" (Dutch), "de" (German)
-- If you want to know what your language code is, open GMod, select a language at the bottom right
-- then enter gmod_language in console. It will show you the code.
-- Make sure language code is a valid entry for the convar gmod_language.
DarkRP.addLanguage("en", my_language)
