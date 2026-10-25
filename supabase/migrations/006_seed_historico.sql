-- ============================================================
-- AMPA Los Lirios — Datos históricos: miembros + actas
-- ============================================================

DO $$
DECLARE
  -- IDs de miembros
  m_ivan uuid;
  m_silvia uuid;
  m_jessica uuid;
  m_jhenny uuid;
  m_patricia uuid;
  m_fatima_m uuid;
  m_laura uuid;
  m_ana uuid;
  m_sandra uuid;
  m_carmen uuid;
  m_fatima_v uuid;
  m_monica uuid;
  m_fatima_r uuid;
  m_cristina uuid;
  m_merche uuid;
  m_monika uuid;
  m_tina uuid;
  m_mariajo uuid;
  m_nazaret uuid;
  m_tamara uuid;
  m_pili uuid;
  -- IDs de actas
  a_79 uuid;
  a_86 uuid;
  a_87 uuid;
  a_88 uuid;
  a_89 uuid;
BEGIN

-- ============================================================
-- MIEMBROS
-- ============================================================

INSERT INTO miembros_ampa (nombre_completo, dni, telefono, email, activo, notas)
VALUES ('Iván Zarza', '47357954B', null, 'ivanzarzaestevez@gmail.com', true, 'Desarrollador web del AMPA. Fue secretario y luego presidente.')
RETURNING id INTO m_ivan;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Silvia Virosta González', '48821618R', true, 'Presidenta hasta junio 2026')
RETURNING id INTO m_silvia;

INSERT INTO miembros_ampa (nombre_completo, dni, activo)
VALUES ('Jessica Fernández Pastor', '30240199Y', true)
RETURNING id INTO m_jessica;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Jhenny Lizeth Rocha Barrionuevo', 'Y6102270Q', true, 'También conocida como Valle / Lizeth Valle')
RETURNING id INTO m_jhenny;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Patricia', '53281925X', true, 'Tesorera hasta junio 2026. Apellido pendiente de confirmar.')
RETURNING id INTO m_patricia;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Fátima Moreno', '28933938F', true, 'Vicepresidenta hasta junio 2026')
RETURNING id INTO m_fatima_m;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Laura', '53271864T', true, 'Apellido pendiente. Vicepresidenta actual.')
RETURNING id INTO m_laura;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Ana', null, true, 'Presidenta actual 2026-2027. DNI pendiente.')
RETURNING id INTO m_ana;

INSERT INTO miembros_ampa (nombre_completo, dni, activo, notas)
VALUES ('Sandra', null, true, 'Tesorera actual 2026-2027. DNI pendiente.')
RETURNING id INTO m_sandra;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Carmen Flor', true)
RETURNING id INTO m_carmen;

INSERT INTO miembros_ampa (nombre_completo, activo, notas)
VALUES ('Fátima V.', true, 'También aparece como Faty en algunas actas')
RETURNING id INTO m_fatima_v;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Mónica', true)
RETURNING id INTO m_monica;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Fátima R.', true)
RETURNING id INTO m_fatima_r;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Cristina', true)
RETURNING id INTO m_cristina;

INSERT INTO miembros_ampa (nombre_completo, activo, notas)
VALUES ('Mercedes', true, 'También aparece como Merche')
RETURNING id INTO m_merche;

INSERT INTO miembros_ampa (nombre_completo, activo, notas)
VALUES ('Mónika', true, 'Con k — persona distinta de Mónica')
RETURNING id INTO m_monika;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Tina', true)
RETURNING id INTO m_tina;

INSERT INTO miembros_ampa (nombre_completo, activo, notas)
VALUES ('María José', true, 'También aparece como Mariajo')
RETURNING id INTO m_mariajo;

INSERT INTO miembros_ampa (nombre_completo, activo, notas)
VALUES ('Nazaret', true, 'También aparece como Nazareth')
RETURNING id INTO m_nazaret;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Tamara', true)
RETURNING id INTO m_tamara;

INSERT INTO miembros_ampa (nombre_completo, activo)
VALUES ('Pili', true)
RETURNING id INTO m_pili;

-- ============================================================
-- CARGOS HISTÓRICOS
-- ============================================================

-- Directiva antigua (Silvia presidenta) — fecha inicio estimada
INSERT INTO miembros_cargos (miembro_id, cargo, fecha_inicio, fecha_fin) VALUES
  (m_silvia,   'Presidenta',      '2022-09-01', '2026-06-19'),
  (m_fatima_m, 'Vicepresidenta',  '2022-09-01', '2026-06-19'),
  (m_ivan,     'Secretario',      '2022-09-01', '2026-06-19'),
  (m_patricia, 'Tesorera',        '2022-09-01', '2026-06-19');

-- Directiva transitoria (Iván presidente, desde cambio directiva 19/06/2026)
INSERT INTO miembros_cargos (miembro_id, cargo, fecha_inicio, fecha_fin) VALUES
  (m_ivan,   'Presidente',  '2026-06-19', '2026-09-01'),
  (m_jessica, 'Tesorera',   '2026-06-19', '2026-09-01'),
  (m_jhenny, 'Secretaria',  '2026-06-19', '2026-09-01');

-- Directiva actual 2026-2027 (según usuario)
INSERT INTO miembros_cargos (miembro_id, cargo, fecha_inicio) VALUES
  (m_ana,     'Presidenta',     '2026-09-01'),
  (m_laura,   'Vicepresidenta', '2026-09-01'),
  (m_sandra,  'Tesorera',       '2026-09-01'),
  (m_jessica, 'Secretaria',     '2026-09-01');

-- Vocales / colaboradores conocidos
INSERT INTO miembros_cargos (miembro_id, cargo, fecha_inicio) VALUES
  (m_silvia,   'Colaboradora', '2026-09-01'),
  (m_fatima_m, 'Colaboradora', '2026-09-01'),
  (m_ivan,     'Colaborador',  '2026-09-01');

-- ============================================================
-- ACTA nº 79 — Reunión Ordinaria, 15 Sept 2025
-- (Nota: la numeración sugiere que podría ser Sept 2022;
--  se importa con la fecha que indica el documento HTML.)
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, hora_inicio, hora_fin, lugar, estado)
VALUES (79, 'ordinaria', '2025-2026', '2025-09-15', '17:00', '18:30', 'Biblioteca del C.E.I.P. Andalucía', 'finalizada')
RETURNING id INTO a_79;

INSERT INTO actas_asistentes (acta_id, miembro_id, nombre_snapshot, dni_snapshot, cargo_snapshot) VALUES
  (a_79, m_silvia,   'Silvia Virosta González', '48821618R', 'Presidenta'),
  (a_79, m_fatima_m, 'Fátima Moreno',           '28933938F', 'Vicepresidenta'),
  (a_79, m_carmen,   'Carmen Flor',              null, null),
  (a_79, m_ivan,     'Iván Zarza',              '47357954B', 'Secretario'),
  (a_79, m_fatima_v, 'Fátima V.',               null, null),
  (a_79, m_patricia, 'Patricia',                '53281925X', 'Tesorera'),
  (a_79, m_monica,   'Mónica',                  null, null),
  (a_79, m_fatima_r, 'Fátima R.',               null, null),
  (a_79, m_cristina, 'Cristina',                null, null),
  (a_79, m_merche,   'Merche',                  null, null),
  (a_79, m_monika,   'Mónika',                  null, null),
  (a_79, m_tina,     'Tina',                    null, null),
  (a_79, m_mariajo,  'María José',              null, null);

INSERT INTO actas_puntos (acta_id, orden, titulo, desarrollo, resultado_votacion) VALUES
  (a_79, 1,  'PROYECTOS PRESENTADOS AL AYUNTAMIENTO', 'Se informa que se presentó al Ayuntamiento el proyecto Mentor 10 y la fiesta de Halloween. Se han aprobado los presupuestos correspondientes.', 'Aprobado por mayoría absoluta'),
  (a_79, 2,  'SORTEO DE RIFA PARA SOCIOS', 'Se aprueba realizar un sorteo de rifa para gastar en la librería Pisapapeles y/o hacer un sorteo de cara a las navidades para socios del AMPA.', 'Aprobado por mayoría absoluta'),
  (a_79, 3,  'HORARIOS DE PAGO DE CUOTAS', 'Se llega a consenso que los lunes y miércoles se abrirá el AMPA para el pago de socios de 9:15 a 10:15h.', 'Aprobado por mayoría absoluta'),
  (a_79, 4,  'PROYECTOS SUBVENCIÓN JUNTA DE ANDALUCÍA', 'Se abordan los proyectos que hay que mejorar para la aprobación de la subvención de la Junta de Andalucía. Se trabajará en la mejora de los mismos.', 'Aprobado por mayoría absoluta'),
  (a_79, 5,  'PRESENTACIÓN CARNETS DE SOCIO', 'Se presentan los carnets de socio para el curso actual.', 'Aprobado por mayoría absoluta'),
  (a_79, 6,  'ORGANIZACIÓN FIESTAS DEL COLEGIO', 'Se acuerda buscar ayuda de los padres para la organización de las fiestas en el colegio.', 'Aprobado por mayoría absoluta'),
  (a_79, 7,  'CALENDARIO COBRO A SOCIOS', 'Se establece que el cobro a socios se acaba el miércoles 12 de noviembre y se reabrirá en enero.', 'Aprobado por mayoría absoluta'),
  (a_79, 8,  'CAMISETAS DEL CORAZÓN', 'Se designa que para las camisetas del corazón se encargarán Mónika y Silvia.', 'Aprobado por mayoría absoluta'),
  (a_79, 9,  'FUNCIONAMIENTO CUENTA BANCARIA', 'Se explica el funcionamiento de la cuenta bancaria. Están cuatro personas de la junta directiva autorizadas en la cuenta, y solo se podrá realizar algún pago, retirada o más gestiones con 2 personas presentes o con la autorización online de 2 personas.', 'Aprobado por mayoría absoluta'),
  (a_79, 10, 'RESPONSABILIDADES REDES SOCIALES', 'Se designa que Iván se encargará de las redes sociales del AMPA.', 'Aprobado por mayoría absoluta'),
  (a_79, 11, 'REPRESENTANTE CONSEJO ESCOLAR', 'Se confirma que la vicepresidenta Fátima continúa como representante del AMPA en el consejo escolar.', 'Aprobado por mayoría absoluta'),
  (a_79, 12, 'RUEGOS Y PREGUNTAS', 'No hay ninguno.', null);

-- ============================================================
-- ACTA nº 86 — Reunión Ordinaria, 29 Abril 2025
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, hora_inicio, hora_fin, lugar, estado)
VALUES (86, 'ordinaria', '2024-2025', '2025-04-29', '12:00', '13:30', 'Biblioteca del C.E.I.P. Andalucía', 'finalizada')
RETURNING id INTO a_86;

INSERT INTO actas_asistentes (acta_id, miembro_id, nombre_snapshot, dni_snapshot, cargo_snapshot) VALUES
  (a_86, m_silvia,   'Silvia Virosta González', '48821618R', 'Presidenta'),
  (a_86, m_fatima_v, 'Fátima V.',               null, null),
  (a_86, m_patricia, 'Patricia',                '53281925X', 'Tesorera'),
  (a_86, m_monica,   'Mónica',                  null, null),
  (a_86, m_fatima_r, 'Fátima R.',               null, null),
  (a_86, m_cristina, 'Cristina',                null, null),
  (a_86, m_merche,   'Mercedes',                null, null),
  (a_86, m_ivan,     'Iván Zarza',              '47357954B', 'Secretario');

INSERT INTO actas_puntos (acta_id, orden, titulo, desarrollo, resultado_votacion) VALUES
  (a_86, 1, 'CARNET DE SOCIOS Y CONTRATOS', 'Se procede a dejar preparado el carnet de socios y el listado de empresas y contratos firmados para el próximo año.', 'Aprobado por mayoría absoluta'),
  (a_86, 2, 'BUZÓN DE SUGERENCIAS', 'Se propone crear un buzón de sugerencias para el alumnado mediante una caja de cartón, una carta por clase (ejemplo: solicitud de taquillas para las clases). Mercedes se encarga de realizarlo. El objetivo es que aporten ideas de mejora y solicitar posteriormente la subvención de la Junta de Andalucía.', 'Aprobado por mayoría absoluta'),
  (a_86, 3, 'SUBVENCIÓN AYUNTAMIENTO', 'El Ayuntamiento aporta a cada AMPA 1.500€ a gastar desde ahora hasta final de diciembre, con empresas de Camas afiliadas. Se acuerda contactar con la empresa Elalua Animación para que proporcione presupuestos y realizar los proyectos correspondientes.', 'Aprobado por mayoría absoluta'),
  (a_86, 4, 'PROYECTOS CURSO 2025/2026', 'Se acuerda presentar los proyectos del año que viene antes de que finalice el curso. Se especifica que tienen que ser proyectos escolares, no valen compras de material.', 'Aprobado por mayoría absoluta'),
  (a_86, 5, 'COMPRAS NAVIDEÑAS', 'Se aprueba la compra de máquina de café de cápsulas y fondo de navidad para el Belén.', 'Aprobado por mayoría absoluta'),
  (a_86, 6, 'INSTALACIONES - GIMNASIO', 'Se acuerda solicitar al director Don Guillermo Salas la colocación de agarres en el techo del gimnasio para colocar el telón de Reyes.', 'Aprobado por mayoría absoluta'),
  (a_86, 7, 'FIESTA FIN DE CURSO', 'Se aprueba la realización de la fiesta de fin de curso para socios del AMPA el día 19 de junio. Se confirma la realización de fiesta de espuma.', 'Aprobado por mayoría absoluta'),
  (a_86, 8, 'COMPRAS DIVERSAS', 'Para el año que viene el AMPA comprará: caramelos de Reyes, agua y caramelos de menta para los mayores (50 unidades). Se acuerda realizar las compras de papelería en Plástico Sur. Se propone comprar mandarinas para Halloween en comercio local.', 'Aprobado por mayoría absoluta'),
  (a_86, 9, 'RUEGOS Y PREGUNTAS', 'No hay ninguno.', null);

-- ============================================================
-- ACTA nº 87 — Asamblea General, 23 Julio 2025
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, hora_inicio, hora_fin, lugar, estado, lectura_acta_anterior)
VALUES (87, 'asamblea_general', '2024-2025', '2025-07-23', '09:15', '10:30', 'Sala del AMPA', 'finalizada', true)
RETURNING id INTO a_87;

INSERT INTO actas_asistentes (acta_id, miembro_id, nombre_snapshot, dni_snapshot, cargo_snapshot) VALUES
  (a_87, m_silvia,   'Silvia',      '48821618R', 'Presidenta'),
  (a_87, m_fatima_m, 'Fátima',      '28933938F', 'Vicepresidenta'),
  (a_87, m_ivan,     'Iván',        '47357954B', 'Secretario'),
  (a_87, m_patricia, 'Patricia',    '53281925X', 'Tesorera'),
  (a_87, m_merche,   'Merche',      null, null),
  (a_87, m_monika,   'Mónika',      null, null),
  (a_87, m_jhenny,   'Valle',       'Y6102270Q', null),
  (a_87, m_fatima_r, 'Fátima R.',   null, null),
  (a_87, m_nazaret,  'Nazaret',     null, null),
  (a_87, m_mariajo,  'María José',  null, null),
  (a_87, m_cristina, 'Cristina',    null, null);

INSERT INTO actas_puntos (acta_id, orden, titulo, desarrollo, resultado_votacion) VALUES
  (a_87, 1, 'Resumen con delegada de Educación Luna Ojeda', 'Solicitado pintar el suelo de infantil, aprobado por el ayuntamiento. Escrito de cableado presentado de todas las AMPAs al ayuntamiento; les contesta la Junta, dicen que es competencia local y el ayuntamiento lo deriva a jurídico.', 'Informativo'),
  (a_87, 2, 'Actividades para el siguiente curso', 'Cuota socios siguiente curso igual: 20€ por alumn@ y 5€ por herman@. Carnet de socios preparados en Pisapapeles. Comercios colaboradores con carteles firmados: Pisapapeles, Martioli, Kebab Nueva Avenida, Cortes Masajes, Pastelería La Mariana, Joy Animación, Uñas Manoli, Deportes Álava, Shuri The Kárate del Centro.', 'Aprobado por unanimidad'),
  (a_87, 3, 'Proyectos a presentar en la Junta de Andalucía para voluntariado de AMPA', 'Se va a presentar festividades de AMPA como: Fiesta de Navidad, Fiesta de espuma, Talleres de caretas carnavales y Taller cuenta cuentos por el día del Libro.', 'Aprobado por unanimidad'),
  (a_87, 4, 'Estado de cuentas fin de curso', 'Gastos del curso: Fiesta de la espuma de socios AMPA: 1.026,82€; Navidad: 1.010,01€; Halloween: 33,50€; Carrera solidaria (chocolate alérgicos): 6,90€; Desayuno Andaluz (servilletas y azúcar): 8,10€; Varios (compras de fondo y suelo de Belén, cortinas tronos, frigorífico segunda mano): 220,56€. Total gastos: 2.305,89€.', 'Informativo'),
  (a_87, 5, 'Continuidad en AMPA siguiente curso', 'Continúan los asistentes. En septiembre salen algunas vocales por motivos personales, a confirmar en fecha.', 'Informativo');

-- ============================================================
-- ACTA nº 88 — Cambio de Directiva, 7 Mayo 2026
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, hora_inicio, hora_fin, lugar, estado)
VALUES (88, 'cambio_directiva', '2025-2026', '2026-05-07', '19:00', '20:15', 'Biblioteca del C.E.I.P. Andalucía', 'finalizada')
RETURNING id INTO a_88;

INSERT INTO actas_asistentes (acta_id, miembro_id, nombre_snapshot, dni_snapshot, cargo_snapshot) VALUES
  (a_88, m_silvia,   'Silvia',       '48821618R', 'Presidenta'),
  (a_88, m_fatima_v, 'Faty',         null, null),
  (a_88, m_laura,    'Laura',        '53271864T', null),
  (a_88, m_nazaret,  'Nazareth',     null, null),
  (a_88, m_tina,     'Tina',         null, null),
  (a_88, m_mariajo,  'Mariajo',      null, null),
  (a_88, m_tamara,   'Tamara',       null, null),
  (a_88, m_pili,     'Pili',         null, null),
  (a_88, m_monika,   'Monika',       null, null),
  (a_88, m_jessica,  'Jessica',      '30240199Y', null),
  (a_88, m_merche,   'Merche',       null, null),
  (a_88, m_jhenny,   'Lizeth Valle', 'Y6102270Q', null),
  (a_88, m_fatima_m, 'Fatima',       '28933938F', 'Vicepresidenta'),
  (a_88, m_ivan,     'Iván',         '47357954B', 'Secretario');

INSERT INTO actas_puntos (acta_id, orden, titulo, desarrollo, resultado_votacion) VALUES
  (a_88, 1, 'Renovación de cargos', 'Se acuerda disolver la Junta Directiva anterior y proceder al nombramiento de los nuevos miembros. Presidencia: sale Silvia Virosta González, entra Iván Zarza. Tesorería: sale Patricia (Patri), entra Jessica Fernández Pastor. Vicepresidencia: sale Fátima Moreno, queda vacante. Secretaría: sale Iván Zarza, entra Jhenny Lizeth Rocha Barrionuevo.', 'Aprobado por mayoría absoluta'),
  (a_88, 2, 'Entrega de documentación', 'La Presidenta saliente, Silvia Virosta González, hace entrega de los libros de Caja, de Socios y de Cuentas, la carpeta de estatutos y de recibos, las llaves y el sello del AMPA. Informa sobre las cuentas y entrega del dinero en mano a la nueva Tesorera. Además se entregan el Libro de Actas y un dispositivo USB con documentación.', 'Informativo'),
  (a_88, 3, 'Ruegos y preguntas', 'No se recogen ruegos significativos.', null);

-- ============================================================
-- ACTA nº 89 — Cambio de Directiva (registro definitivo), 19 Junio 2026
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, hora_inicio, hora_fin, lugar, estado)
VALUES (89, 'cambio_directiva', '2025-2026', '2026-06-19', '19:00', '20:15', 'Biblioteca del C.E.I.P. Andalucía', 'finalizada')
RETURNING id INTO a_89;

INSERT INTO actas_asistentes (acta_id, miembro_id, nombre_snapshot, dni_snapshot, cargo_snapshot) VALUES
  (a_89, m_silvia,   'Silvia',       '48821618R', 'Presidenta saliente'),
  (a_89, m_fatima_v, 'Faty',         null, null),
  (a_89, m_laura,    'Laura',        '53271864T', null),
  (a_89, m_nazaret,  'Nazareth',     null, null),
  (a_89, m_tina,     'Tina',         null, null),
  (a_89, m_mariajo,  'Mariajo',      null, null),
  (a_89, m_tamara,   'Tamara',       null, null),
  (a_89, m_pili,     'Pili',         null, null),
  (a_89, m_monika,   'Monika',       null, null),
  (a_89, m_jessica,  'Jessica',      '30240199Y', 'Tesorera entrante'),
  (a_89, m_merche,   'Merche',       null, null),
  (a_89, m_jhenny,   'Lizeth Valle', 'Y6102270Q', 'Secretaria entrante'),
  (a_89, m_fatima_m, 'Fatima',       '28933938F', 'Vicepresidenta saliente'),
  (a_89, m_ivan,     'Iván',         '47357954B', 'Presidente entrante');

INSERT INTO actas_puntos (acta_id, orden, titulo, desarrollo, resultado_votacion) VALUES
  (a_89, 1, 'Renovación de cargos', 'Se acuerda disolver la Junta Directiva anterior y proceder al nombramiento de los nuevos miembros. Presidencia: sale Silvia Virosta González (DNI 48821618R), entra Iván Zarza (DNI 47357954B). Tesorería: sale Patricia (DNI 53281925X), entra Jessica Fernández Pastor (DNI 30240199Y). Vicepresidencia: sale Fátima Moreno (DNI 28933938F), queda vacante. Secretaría: sale Iván Zarza, entra Jhenny Lizeth Rocha Barrionuevo (DNI Y6102270Q).', 'Aprobado por mayoría absoluta'),
  (a_89, 2, 'Entrega de documentación', 'La Presidenta saliente hace entrega de libros de Caja, Socios y Cuentas, carpeta de estatutos y recibos, llaves y sello. Patricia, como Tesorera saliente, hace entrega de 2.423,82€ en efectivo a la nueva Tesorera, Jessica Fernández Pastor.', 'Informativo'),
  (a_89, 3, 'Ruegos y preguntas', 'No se recogen ruegos significativos.', null);

-- ============================================================
-- ACTAS HISTÓRICAS (solo metadatos, contenido en .docx)
-- Estado 'pendiente_revision' para diferenciarlas de las completas.
-- Las fechas son aproximadas según la carpeta donde se encontraron.
-- ============================================================

INSERT INTO actas (numero, tipo, curso_escolar, fecha, lugar, estado, notas_brutas) VALUES
  (33, 'ordinaria', '2017-2018', '2018-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº 33.docx — contenido pendiente de transcribir'),
  (51, 'ordinaria', '2019-2020', '2020-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº51.docx'),
  (52, 'ordinaria', '2019-2020', '2020-02-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº52.docx'),
  (53, 'ordinaria', '2019-2020', '2020-03-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº53.docx'),
  (54, 'ordinaria', '2019-2020', '2020-04-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº54.docx'),
  (55, 'ordinaria', '2019-2020', '2020-05-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº55.docx'),
  (56, 'ordinaria', '2020-2021', '2020-10-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº56.docx'),
  (57, 'ordinaria', '2020-2021', '2020-11-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº57.docx'),
  (58, 'ordinaria', '2020-2021', '2021-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº58.docx'),
  (59, 'ordinaria', '2020-2021', '2021-02-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº59.docx'),
  (60, 'ordinaria', '2020-2021', '2021-03-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº60.docx'),
  (61, 'ordinaria', '2020-2021', '2021-04-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº61.docx'),
  (62, 'ordinaria', '2021-2022', '2021-10-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº62.docx'),
  (63, 'ordinaria', '2021-2022', '2021-11-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº63.docx'),
  (64, 'ordinaria', '2021-2022', '2022-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº64.docx'),
  (65, 'ordinaria', '2021-2022', '2022-02-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº65.docx'),
  (71, 'ordinaria', '2022-2023', '2022-09-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº 71.doc'),
  (72, 'ordinaria', '2022-2023', '2022-10-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº 72.docx'),
  (73, 'ordinaria', '2022-2023', '2023-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº 73.docx'),
  (74, 'ordinaria', '2022-2023', '2023-02-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde Acta nº 74.docx'),
  (82, 'ordinaria', '2023-2024', '2024-01-15', 'Sala del AMPA', 'pendiente_revision', 'Importado desde ACTA Nº 82.docx');

END $$;
