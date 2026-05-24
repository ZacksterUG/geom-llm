--liquibase formatted sql

--changeset ahmedyanov:5
-- Задача 1: Скрещивающиеся диагонали граней куба
UPDATE tasks
SET
    condition_text = 'В кубе $ABCDA_1B_1C_1D_1$ докажите, что диагональ $A_1C_1$ верхней грани и диагональ $AD_1$ боковой грани являются скрещивающимися прямыми.',
    initial_figure_state = REPLACE(
        REPLACE(
            initial_figure_state::text,
            '"ABCD - нижнее основание куба"',
            '"$ABCD$ - нижнее основание куба"'
        ),
        '"A1B1C1D1 - верхняя грань куба"',
        '"$A_1B_1C_1D_1$ - верхняя грань куба"'
    )::jsonb,
    reference_figure_state = REPLACE(
        REPLACE(
            reference_figure_state::text,
            '"A1C1 - диагональ верхней грани"',
            '"$A_1C_1$ - диагональ верхней грани"'
        ),
        '"AD1 - диагональ боковой грани"',
        '"$AD_1$ - диагональ боковой грани"'
    )::jsonb,
    reference_proof = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    reference_proof::text,
                    'A1B1C1D1',
                    '$A_1B_1C_1D_1$'
                ),
                'A1C1',
                '$A_1C_1$'
            ),
            'AD1',
            '$AD_1$'
        ),
        'D1',
        '$D_1$'
    )::jsonb
WHERE title = 'Скрещивающиеся диагонали граней куба';

--changeset ahmedyanov:6
-- Задача 2: Теорема о диагонали прямоугольного параллелепипеда
UPDATE tasks
SET
    condition_text = 'В прямоугольном параллелепипеде $ABCDA_1B_1C_1D_1$ докажите, что квадрат диагонали равен сумме квадратов трех его измерений: $AC_1^2 = AB^2 + AD^2 + AA_1^2$.',
    initial_figure_state = REPLACE(
        REPLACE(
            REPLACE(
                initial_figure_state::text,
                '"ABCD - основание (прямоугольник)"',
                '"$ABCD$ - основание (прямоугольник)"'
            ),
            '"A1B1C1D1 - верхняя грань"',
            '"$A_1B_1C_1D_1$ - верхняя грань"'
        ),
        '"AB = 4, AD = 3, AA1 = 2"',
        '"$AB = 4$, $AD = 3$, $AA_1 = 2$"'
    )::jsonb,
    reference_figure_state = REPLACE(
        REPLACE(
            REPLACE(
                reference_figure_state::text,
                '"ABCD - основание (прямоугольник)"',
                '"$ABCD$ - основание (прямоугольник)"'
            ),
            '"AC - диагональ основания"',
            '"$AC$ - диагональ основания"'
        ),
        '"AC1 - диагональ параллелепипеда"',
        '"$AC_1$ - диагональ параллелепипеда"'
    )::jsonb,
    reference_proof = REPLACE(
        REPLACE(
            REPLACE(
                reference_proof::text,
                'AA1',
                '$AA_1$'
            ),
            'AC1',
            '$AC_1$'
        ),
        'CC1',
        '$CC_1$'
    )::jsonb
WHERE title = 'Теорема о диагонали прямоугольного параллелепипеда';

--changeset ahmedyanov:7
-- Задача 3: Перпендикулярность диагонали куба и плоскости
UPDATE tasks
SET
    condition_text = 'В кубе $ABCDA_1B_1C_1D_1$ докажите, что диагональ $A_1C$ перпендикулярна плоскости $AB_1D_1$.',
    initial_figure_state = REPLACE(
        REPLACE(
            initial_figure_state::text,
            '"ABCD - нижнее основание куба"',
            '"$ABCD$ - нижнее основание куба"'
        ),
        '"A1B1C1D1 - верхняя грань куба"',
        '"$A_1B_1C_1D_1$ - верхняя грань куба"'
    )::jsonb,
    reference_figure_state = REPLACE(
        REPLACE(
            reference_figure_state::text,
            '"A1C - диагональ куба"',
            '"$A_1C$ - диагональ куба"'
        ),
        '"AB1D1 - плоскость сечения"',
        '"$AB_1D_1$ - плоскость сечения"'
    )::jsonb,
    reference_proof = REPLACE(
        REPLACE(
            REPLACE(
                reference_proof::text,
                'A1C',
                '$A_1C$'
            ),
            'AB1',
            '$AB_1$'
        ),
        'AD1',
        '$AD_1$'
    )::jsonb
WHERE title = 'Перпендикулярность диагонали куба и плоскости';

--changeset ahmedyanov:8
-- Задача 4: Параллельность прямой и плоскости в призме
UPDATE tasks
SET
    condition_text = 'В правильной четырёхугольной призме $ABCDA_1B_1C_1D_1$ точки $M$ и $N$ — середины рёбер $A_1B_1$ и $B_1C_1$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ABC_1$.',
    initial_figure_state = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    initial_figure_state::text,
                    '"ABCD - нижнее основание призмы"',
                    '"$ABCD$ - нижнее основание призмы"'
                ),
                '"A1B1C1D1 - верхнее основание призмы"',
                '"$A_1B_1C_1D_1$ - верхнее основание призмы"'
            ),
            '"M - середина A1B1"',
            '"$M$ - середина $A_1B_1$"'
        ),
        '"N - середина B1C1"',
        '"$N$ - середина $B_1C_1$"'
    )::jsonb,
    reference_figure_state = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            reference_figure_state::text,
                            '"ABCD - нижнее основание призмы"',
                            '"$ABCD$ - нижнее основание призмы"'
                        ),
                        '"A1B1C1D1 - верхнее основание призмы"',
                        '"$A_1B_1C_1D_1$ - верхнее основание призмы"'
                    ),
                    '"M - середина A1B1"',
                    '"$M$ - середина $A_1B_1$"'
                ),
                '"N - середина B1C1"',
                '"$N$ - середина $B_1C_1$"'
            ),
            '"MN - средняя линия треугольника A1B1C1"',
            '"$MN$ - средняя линия треугольника $A_1B_1C_1$"'
        ),
        '"AC1 - диагональ плоскости ABC1"',
        '"$AC_1$ - диагональ плоскости $ABC_1$"'
    )::jsonb,
    reference_proof = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    reference_proof::text,
                    'A1B1',
                    '$A_1B_1$'
                ),
                'B1C1',
                '$B_1C_1$'
            ),
            'A1C1',
            '$A_1C_1$'
        ),
        'ABC1',
        '$ABC_1$'
    )::jsonb
WHERE title = 'Параллельность прямой и плоскости в призме';
