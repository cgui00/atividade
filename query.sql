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
