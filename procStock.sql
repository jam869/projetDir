DELIMITER //

-- =========================
-- US-01 : Création de compte
-- =========================
CREATE PROCEDURE sp_RegisterUser(
    IN p_Alias VARCHAR(30),
    IN p_Email VARCHAR(254), 
    IN p_Password VARCHAR(255)
)
BEGIN
    -- Vérification si l'alias ou l'email existe déjà
    IF EXISTS (SELECT 1 FROM Users WHERE Alias = p_Alias) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cet alias est déjà utilisé.';
    ELSE IF p_Email IS NOT NULL AND EXISTS (SELECT 1 FROM Users WHERE Email = p_Email) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cet email est déjà utilisé.';
        -- L'insertion se fait ici, quand l'alias et l'email sont libres
        INSERT INTO Users (Alias, Email, Password, Role, Gold, Silver, Bronze)
        VALUES (p_Alias, p_Email, p_Password, 'Joueur', 1000, 1000, 1000); 
    END IF;
END //

-- =========================
-- US-02 : Connexion
-- =========================
CREATE PROCEDURE sp_GetUserByAlias(
    IN p_Alias VARCHAR(30)
)   
BEGIN
    -- Récupère toutes les infos nécessaires pour la session
    SELECT UserId, Alias, Email, Password, Role, Gold, Silver, Bronze
    FROM Users
    WHERE Alias = p_Alias;
END //

DELIMITER ;