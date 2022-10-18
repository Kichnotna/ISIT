(deffunction ask-value (?question)
    (print ?question)
    (bind ?answer (read))
    ?answer
    )

(deffunction ask-question (?question $?allowed-values)
    (print ?question)
    (bind ?answer (read))
    (if (lexemep ?answer)
        then (bind ?answer (lowcase ?answer))
	    )
    (while (not (member$ ?answer ?allowed-values)) do
        (print ?question)
        (bind ?answer (read))
        (if (lexemep ?answer)
            then (bind ?answer (lowcase ?answer))
		    )
	    )
    ?answer
    )

(deffunction yes-or-no (?question)
    (bind ?response (ask-question ?question yes no y n))
        (if (or (eq ?response yes) (eq ?response y))
            then yes
            else no
        )
)





(defrule ask-peripherals "Перефирия"
    (not (solution ?))
    (not (peripherals ?))
    =>
    (assert (peripherals (yes-or-no "Переферия работает?")))
)

(defrule ask-shutdown "Выкл ПК"
    (not (solution ?))
    (not (shutdown ?))
    =>
    (assert (shutdown (yes-or-no "ПК самопроизвольно выключается?")))
)

(defrule ask-beep "Звуковой сигнал"
    (not (solution ?))
    (not (beep ?))
    =>
    (assert (beep (yes-or-no "При включении слышен короткий звуковой сигнал?")))
)

(defrule ask-loadOS "Загрузка ОС"
    (not (solution ?))
    (not (loadOS ?))
    =>
    (assert (loadOS (yes-or-no "ОС загружается?")))
)

(defrule ask-turnON "Вкл ПК"
    (not (solution ?))
    (not (turnON ?))
    =>
    (assert (turnON (yes-or-no "ПК включается?")))
)

(defrule ask-artifacts "Артифакты"
    (not (solution ?))
    (not (artifacts ?))
    =>
    (assert (artifacts (yes-or-no "На экране появляются артифакты?")))
)

(defrule ask-load "Перезагрузка ПК"
    (not (solution ?))
    (not (load ?))
    =>
    (assert (load (yes-or-no "ПК произвольно перезагружается?")))
)

(defrule ask-burnSmell "Запах гари"
    (not (solution ?))
    (not (burnSmell ?))
    =>
    (assert (burnSmell (yes-or-no "Чувствуется запах гари?")))
)

(defrule ask-picture "Изображение"
    (not (solution ?))
    (not (picture ?))
    =>
    (assert (picture (yes-or-no "Есть изображение на мониторе?")))
)

(defrule ask-temp "Температура"
    (not (solution ?))
    (not (temp ?))
    =>
    (assert (temp (ask-value "Какая температура процессора?")))
)

(defrule ask-bsod "Синий экран смерти"
    (not (solution ?))
    (not (bsod ?))
    =>
    (assert (bsod (ask-value "Появляется синий экран смерти?")))
)

(defrule ask-lags "Лаги"
    (not (solution ?))
    (not (lags ?))
    =>
    (assert (lags (ask-value "ПК лагает?")))
)





(defrule rule-errorBIOS "Ошибка БИОС"
    (and
        (and
            (peripherals no)
            (shutdown yes)
        )
        (beep no)
    )
    (not (solution ?))
    =>
    (assert (errorBIOS yes))
        (print "Вероятнее всего, у вас слетели настройки BIOS" crlf) 
)

(defrule rule-southBridge "Южный мост"
    (or
        (turnON yes)
        (artifacts yes)
    )
    (not (solution ?))
    =>
    (assert (southBridge yes))
        (print "Вероятнее всего, у вас проблемы с южным мостом" crlf) 
)

(defrule rule-northBridge "Северный мост"
    (or
        (reboot yes)
        (shutdown yes)
    )
    (not (solution ?))
    =>
    (assert (northBridge yes))
        (print "Вероятнее всего, у вас проблемы с северным мостом" crlf) 
)

(defrule rule-overheat "Перегрев"
    (or
        (and
            (burnSmell yes)
            (picture no)
        )
        (temp > 90)
    )
    (not (solution ?))
    =>
    (assert (overheat yes))
        (print "Вероятнее всего, у вас перегрев" crlf) 
)

(defrule rule-legs "Ножки"
    (picture yes)
    (not (solution ?))
    =>
    (assert (legs yes))
        (print "Вероятнее всего, у вас погнуты ножки" crlf) 
)










(defrule rule-bios "BIOS"
    (or   
        (errorBIOS yes)
        (loadOS no)
    )
    (not (solution ?))
    =>
    (assert (bios yes))
        (print "Верятнее всего, проблема в BIOS" crlf)
)

(defrule rule-pb "PB"
    (turnON yes)
    (not (solution ?))
    =>
    (assert (pb yes))
        (print "Верятнее всего, проблема с блоком питания" crlf)
)

(defrule rule-mb "MB"
    (or
            (southBridge yes)
            (northBridge yes)
    )
    (not (solution ?))
    =>
    (assert (mb yes))
        (print "Верятнее всего, проблема с материнской платой" crlf)
)

(defrule rule-cpu "CPU"
    (or
            (overheat yes)
            (legs yes)
    )
    (not (solution ?))
    =>
    (assert (cpu yes))
        (print "Верятнее всего, проблема с процессором" crlf)
)

(defrule rule-gpu "GPU"
    (and
            (picture yes)
            (bsod yes)
    )
    (not (solution ?))
    =>
    (assert (gpu yes))
        (print "Верятнее всего, проблема с видеокартой" crlf)
)

(defrule rule-ram "RAM"
    (and
            (bsod no)
            (loadOS no)
    )
    (not (solution ?))
    =>
    (assert (ram yes))
        (print "Верятнее всего, проблема с оперативной памятью" crlf)
)

(defrule rule-hdd "HDD"
    (or
            (lags yes)
            (lreboot yes)
    )
    (not (solution ?))
    =>
    (assert (hdd yes))
        (print "Верятнее всего, проблема с жётким диском" crlf)
)










(defrule rule-idk "Нет ответа"
    (and
        (and
            (and
                (and
                    (and
                        (and
                            (bios yes)
                            (pb yes)
                        )
                        (mb yes)
                    )
                    (cpu yes)
                )
                (gpu yes)
            )
            (ram yes)
        )
        (hdd yes)
    )
    (not (solution ?))
    =>
    (assert (solution yes))
        (print "Верятнее всего, у вас слижком глубокая проблема. Jnytcbnt d cthdbc" crlf)
)

(defrule rule-hdd "Отремантировать"
    (or
        (or
            (bios yes)
            (hdd  yes)
        )
            (ram yes)
    )
    (not (solution ?))
    =>
    (assert (solution yes))
        (print "Побробуйте починить самостоятельно" crlf)
)

(defrule rule-hdd "Замена комплектующих"
    (or
        (or
            (pb yes)
            (mb  yes)
        )
            (gpu yes)
    )
    (not (solution ?))
    =>
    (assert (solution yes))
        (print "Замените комплектующие" crlf)
)