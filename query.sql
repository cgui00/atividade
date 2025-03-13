/*a*/

SELECT 
    o.id_orders AS Pedido_ID,
    p.nomes AS Produto,
    ps.quantitys AS Quantidade
FROM 
    orders o
JOIN 
    productsche ps ON o.id_orders = ps.sId
JOIN 
    products p ON ps.pId = p.id_produto
WHERE 
    o.id_orders = <ID_DO_PEDIDO>;


/*b*/

DELIMITER $$

CREATE PROCEDURE LimitarPedidosEmAtendimento(IN idMesa INT)
BEGIN
    -- Verificar se a mesa está em atendimento
    DECLARE mesaStatus VARCHAR(30);
    
    SELECT statu INTO mesaStatus
    FROM orders
    WHERE tld = idMesa
    ORDER BY dates DESC
    LIMIT 1;

    -- Se o status for "open", permite a operação, caso contrário, impede
    IF mesaStatus = 'open' THEN
        -- Permitir a criação de novo pedido
        SELECT 'Mesa está em atendimento. Pedido pode ser feito.';
    ELSE
        -- Impedir novo pedido para mesa que não está em atendimento
        SELECT 'Mesa não está em atendimento. Não é possível realizar o pedido.';
    END IF;
END$$

DELIMITER ;


/*c*/

DELIMITER //

CREATE PROCEDURE update_quantity (
    IN p_sId INT,
    IN p_pId INT,
    IN p_quantitys INT
)
BEGIN
    DECLARE existing_quantity INT;
    
    -- Verifica se a combinação de sId e pId já existe na tabela productsche
    SELECT quantitys INTO existing_quantity
    FROM productsche
    WHERE sId = p_sId AND pId = p_pId;
    
    -- Se existir, atualiza a quantidade
    IF existing_quantity IS NOT NULL THEN
        UPDATE productsche
        SET quantitys = p_quantitys
        WHERE sId = p_sId AND pId = p_pId;
    ELSE
        -- Se não existir, insere um novo registro
        INSERT INTO productsche(sId, pId, quantitys)
        VALUES (p_sId, p_pId, p_quantitys);
    END IF;
END //

DELIMITER ;


/*d*/

SELECT 
    p.nomes AS nome_produto,
    ps.quantitys AS quantidade,
    (ps.quantitys * CAST(p.princes AS DECIMAL(10,2))) AS valor_total_produto,
    SUM(ps.quantitys * CAST(p.princes AS DECIMAL(10,2))) OVER (PARTITION BY o.id_orders) AS valor_total_compra
FROM 
    orders o
JOIN 
    productsche ps ON o.id_orders = ps.sId
JOIN 
    products p ON ps.pId = p.id_produto
WHERE 
    o.statu = 'open';
