Also auf den rat eines Spielers habe ich hier mal einen Mod bei dem ich Hilfe benötige.
Der Werkbank mod bzw dessen Formspec ist fertig, hat aber noch keine Funktion.
Wie im beiliegenden "chainsaw"-Mod sollen in der Werkbank blöcke verändert werden.
Nur statt sie in Treppen, Stufen usw. zu verformen sollen sie in der Werkbank
zu einer farbigen Variante den eigelegten Blockes werden.
Zb. ein Normaler Holzblock (default:wood) soll in das erste Feld gelegt werden. Eine
Farbe in das Zweite Feld (dye:red). Im Dritten Feld soll dann ein Block angezeigt werden
der nun (workbench:wood_red) heißt und die gleichen Eigenschaften hat wie der Ursprungsblock
(default:wood), nur mit einem unterschied das über die Originaltextur eine Farbe gelegt wird,
in diesem fall rot (^[colorize:#ff000080). Eine weitere Funktion soll das Bleichen sein,
in dem der gefärbte Block in das erste Feld gelegt wird und man dann auf "Bleichen" klickt.
Nun soll der Ursprungsblock im dritten Feld auftauchen also (default:wood).
Ferner sollte auch eine Art Blockregistrierung bzw Blockauschluss-funktion enthalten sein,
die ausschließt das man zb Farben färben kann oder ansich items und auch spezielle Blöcke die
nicht umgefärbt werden sollen da das Resultat dann eher sinnlos wäre wie zb beim Kohleblock
der so dunkel ist das die Farbe kaum sichtbar ist.)
Eine Ausnahme beim Färben wäre auch der Wollblock, dieser existiert bereits im "wool"-mod und
muss daher gar nicht eingefärbt werden, da es eine farbige Textur dazu gibt, bzw er schon gefärbt
ist. In dem Fall soll die Werkbank solche Blöcke erkennen und sie nicht umfärben sondern einfach
den bereits vorhandenen Farbblock laden also (wool:wool_red) statt (workbench:wool_red) ohne in einzufärben. Natürlich
soll auch da das Bleichen funktionieren und den (wool:wool_white) statt den (wool:wool_) laden.
Auch wenn es klar sein sollte, schreibe ich das besser noch dazu, wenn aus dem dritten Feld ein Block entnommen wird
bzw auch mehrere, wenn man gleich eine höhere Anzahl Blöcke und Farbe zum färben eingelegt hat,
sollen aus dem ersten und 2ten Feld die Anzahl Blöcke entfernt werden, die im dritten Feld entnommen wurden.
Ergo (default:wood + dye:red = workbench:wood_red / workbench:wood_red (Bleichen) = default:wood)
Die Farbe ist also nach dem Färben ganz weg und das Holz ist im Farbblock bis man ihn bleicht dann verschwindet
der Farbblock und reines Holz bleibt zurück.
Wichtig bei dem ganzen mod ist, das die Farbblöcke nicht jeder einzeln registriert werden und
somit nicht im Craft-Inventar erscheinen. Deshalb hab ich dazu den "chainsaw"-mod hinzugefügt
bei dem das Prinzip gleich ist, nur das dieser den "stairs"-Mod abruft wegen der nodebox, aber das
ist bei der Veränderung der Textur oder der ID Namen nicht nötig.

Ich hoffe ein findiger Programmierer kann mir weiter helfen, da dieser Mod sehr wichtig für
Halloween [Server] Deutsch ist da so viele Blöcke daran hängen.