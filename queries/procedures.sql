/*-- SP cambio de estatus -- */
DELIMITER //

CREATE PROCEDURE sp_registrar_cambio_estatus(
    IN p_id_inscripcion INT,
    IN p_nuevo_estatus VARCHAR(20),
    IN p_motivo VARCHAR(255)
)
BEGIN

    DECLARE v_estatus_actual VARCHAR(20);

    -- Verificar que exista la inscripción y el alumno
     IF NOT EXISTS (
        SELECT 1
        FROM inscripciones i
        INNER JOIN alumnos a
            ON a.id_alumno = i.id_alumno
        WHERE i.id_inscripcion = p_id_inscripcion
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La inscripción o el alumno no existen.';

    ELSE

        

        -- Obtener el estatus actual
        SELECT estatus
        INTO v_estatus_actual
        FROM inscripciones
        WHERE id_inscripcion = p_id_inscripcion;

IF v_estatus_actual = p_nuevo_estatus THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La inscripción ya tiene ese estatus.';
END IF;

START TRANSACTION;
        -- Actualizar el estatus actual
        UPDATE inscripciones
        SET estatus = p_nuevo_estatus
        WHERE id_inscripcion = p_id_inscripcion;

        -- Registrar el movimiento
        INSERT INTO historial_estatus
        (
            id_inscripcion,
            estatus_anterior,
            estatus_nuevo,
            fecha_cambio,
            motivo
        )
        VALUES
        (
            p_id_inscripcion,
            v_estatus_actual,
            p_nuevo_estatus,
            NOW(),
            p_motivo
        );

        COMMIT;

    END IF;

END //

DELIMITER ;

-- ejemplo de uso del stored procedure
CALL sp_registrar_cambio_estatus(
    2,
    'activo',
    'Reingreso del alumno'
);