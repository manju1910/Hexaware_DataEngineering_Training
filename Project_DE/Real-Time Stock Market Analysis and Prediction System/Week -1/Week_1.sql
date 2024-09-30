create database stockmarket
use stockmarket

CREATE TABLE CompanyProfiles (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(255),
    ticker_symbol VARCHAR(10),
    industry VARCHAR(100)
);

CREATE TABLE StockData (
    stock_id INT PRIMARY KEY,
    company_id INT,
    trade_date DATE,
    open_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    high_price DECIMAL(10, 2),
    low_price DECIMAL(10, 2),
    volume BIGINT,
    FOREIGN KEY (company_id) REFERENCES CompanyProfiles(company_id));

	CREATE TABLE MarketIndicators (
    indicator_id INT PRIMARY KEY,
    stock_id INT,
    trade_date DATE,
    rsi DECIMAL(5, 2),
    moving_avg DECIMAL(10, 2),
    bollinger_band_upper DECIMAL(10, 2),
    bollinger_band_lower DECIMAL(10, 2),
    FOREIGN KEY (stock_id) REFERENCES StockData(stock_id)
);


INSERT INTO CompanyProfiles (company_id, company_name, ticker_symbol, industry) 
VALUES 
(1, 'Apple Inc.', 'AAPL', null),
(2, 'Microsoft Corporation', 'MSFT', 'Technology'),
(3, 'Tesla Inc.', 'TSLA', 'Automotive'),
(4, 'Amazon.com Inc.', 'AMZN', 'Retail'),
(5, 'Meta Platforms Inc.', 'META', 'Technology');

INSERT INTO StockData (stock_id, company_id, trade_date, open_price, close_price, high_price, low_price, volume)
VALUES 
(1, 1, '2024-09-01', 150.00, 155.00, 157.00, 148.00, 1000000),
(2, 1, '2024-09-02', 155.00, 160.00, 162.00, 153.00, 1200000),
(3, 2, '2024-09-01', 300.00, 310.00, 315.00, 295.00, 800000),
(4, 2, '2024-09-02', 310.00, 320.00, 325.00, null, 900000),
(5, 3, '2024-09-01', 700.00, 720.00, 730.00, 690.00, 500000),
(6, 3, '2024-09-02', 720.00, 740.00, 750.00, 710.00, 550000),
(7, 4, '2024-09-01', 130.00, 135.00, 137.00, 128.00, 2000000),
(8, 4, '2024-09-02', 135.00, null, 142.00, 133.00, 2200000),
(9, 5, '2024-09-01', 250.00, 255.00, 258.00, 245.00, 1100000),
(10, 5, '2024-09-02', 255.00, 260.00, 265.00, 250.00, 1150000);



INSERT INTO MarketIndicators (indicator_id, stock_id, trade_date, rsi, moving_avg, bollinger_band_upper, bollinger_band_lower)
VALUES 
(1, 1, '2024-09-01', 70.50, 152.00, 160.00, 145.00),
(2, 1, '2024-09-02', 72.00, 156.50, 165.00, 148.00),
(3, 2, '2024-09-01', 65.30, 305.00, 320.00, 290.00),
(4, 2, '2024-09-02', 67.00, 315.00, 325.00, 300.00),
(5, 3, '2024-09-01', 55.00, 715.00, 730.00, 700.00),
(6, 3, '2024-09-02', 60.00, 725.00, 740.00, 710.00),
(7, 4, '2024-09-01', 62.00, 132.50, 140.00, 125.00),
(8, 4, '2024-09-02', 64.00, 137.50, 145.00, 130.00),
(9, 5, '2024-09-01', 68.00, 252.50, 260.00, 245.00),
(10, 5, '2024-09-02', 70.00, 257.50, 265.00, 250.00);



-- 1: Calculate Daily Average Prices for Each Stock

SELECT 
    stock_id, 
    trade_date,
    (high_price + low_price) / 2 AS average_price
FROM 
    StockData;

--2: max min prize
SELECT 
    company_id,
    MAX(high_price) AS max_price,
    MIN(low_price) AS min_price
FROM 
    StockData
GROUP BY 
    company_id;

--3: Calculate Moving Average (e.g., 10-day moving average)

SELECT 
    stock_id,
    trade_date,
    close_price,
    AVG(close_price) OVER (PARTITION BY stock_id ORDER BY trade_date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS moving_avg_10
FROM 
    StockData;

--4: Identify Stocks Crossing Upper Bollinger Band

SELECT 
    s.stock_id, 
    s.trade_date,
    s.close_price,
    m.bollinger_band_upper
FROM 
    StockData s
JOIN 
    MarketIndicators m ON s.stock_id = m.stock_id AND s.trade_date = m.trade_date
WHERE 
    s.close_price > m.bollinger_band_upper;


--5.Calculate the Relative Strength Index (RSI) for Each Stock

SELECT 
    stock_id, 
    trade_date, 
    rsi 
FROM 
    MarketIndicators 
WHERE 
    rsi IS NOT NULL
ORDER BY 
    stock_id, trade_date;

--6.Find Stocks with Volume Greater Than a Specified Threshold (e.g., 1,000,000)

SELECT 
    company_id, 
    trade_date, 
    volume 
FROM 
    StockData 
WHERE 
    volume > 1000000;

--7.Get the Latest Stock Prices for All Companies

SELECT 
    s.company_id, 
    c.company_name, 
    MAX(s.trade_date) AS latest_trade_date, 
    s.close_price 
FROM 
    StockData s
JOIN 
    CompanyProfiles c ON s.company_id = c.company_id
GROUP BY 
    s.company_id, c.company_name, s.close_price;

--8.Find Stocks Where the Close Price Dropped Below the Moving Average

SELECT 
    s.stock_id, 
    s.trade_date, 
    s.close_price, 
    m.moving_avg 
FROM 
    StockData s
JOIN 
    MarketIndicators m ON s.stock_id = m.stock_id AND s.trade_date = m.trade_date
WHERE 
    s.close_price < m.moving_avg;

--9.Calculate the Volatility of a Stock Based on High and Low Prices

SELECT 
    stock_id, 
    trade_date, 
    (high_price - low_price) / low_price * 100 AS volatility_percentage
FROM 
    StockData
WHERE 
    high_price IS NOT NULL AND low_price IS NOT NULL;

--10.Find the Total Trading Volume for Each Stock Over a Given Time Period

SELECT 
    company_id, 
    SUM(volume) AS total_volume 
FROM 
    StockData 
WHERE 
    trade_date BETWEEN '2024-09-01' AND '2024-09-15'
GROUP BY 
    company_id;

--11.Rank Stocks by Their Daily Price Change

SELECT 
    stock_id, 
    trade_date, 
    close_price - open_price AS price_change,
    RANK() OVER (ORDER BY close_price - open_price DESC) AS rank
FROM 
    StockData;






