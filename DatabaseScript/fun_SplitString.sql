/****** Object:  UserDefinedFunction [tallal78_8].[fun_SplitString]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP FUNCTION [tallal78_8].[fun_SplitString]
GO
/****** Object:  UserDefinedFunction [tallal78_8].[fun_SplitString]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [tallal78_8].[fun_SplitString]
    (
      @string VARCHAR(MAX) ,
      @delimiter CHAR(1)
    )
RETURNS @output TABLE ( splitdata VARCHAR(MAX) )
    BEGIN 
        DECLARE @start INT ,
            @end INT 
        SELECT  @start = 1 ,
                @end = CHARINDEX(@delimiter, @string) 
        WHILE @start < LEN(@string) + 1
            BEGIN 
                IF @end = 0
                    SET @end = LEN(@string) + 1
       
                INSERT  INTO @output
                        ( splitdata
                        )
                VALUES  ( RTRIM(LTRIM(SUBSTRING(@string, @start, @end - @start)))
                        ) 
                SET @start = @end + 1 
                SET @end = CHARINDEX(@delimiter, @string, @start)
        
            END 
        RETURN 
    END

GO
