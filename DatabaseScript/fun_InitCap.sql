/****** Object:  UserDefinedFunction [tallal78_8].[fun_InitCap]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP FUNCTION [tallal78_8].[fun_InitCap]
GO
/****** Object:  UserDefinedFunction [tallal78_8].[fun_InitCap]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [tallal78_8].[fun_InitCap]
    (
      @InputString VARCHAR(MAX)
    )
RETURNS VARCHAR(MAX)
AS
    BEGIN

        DECLARE @Index INT
        DECLARE @Char CHAR(1)
        DECLARE @PrevChar CHAR(1)
        DECLARE @OutputString VARCHAR(MAX)

        SET @OutputString = LOWER(@InputString)
        SET @Index = 1

        WHILE @Index <= LEN(@InputString)
            BEGIN
                SET @Char = SUBSTRING(@InputString, @Index, 1)
                SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
                                     ELSE SUBSTRING(@InputString, @Index - 1,
                                                    1)
                                END

                IF @PrevChar IN ( ' ', ';', ':', '!', '?', ',', '.', '_', '-',
                                  '/', '&', '''', '(' )
                    BEGIN
                        IF @PrevChar != ''''
                            OR UPPER(@Char) != 'S'
                            SET @OutputString = STUFF(@OutputString, @Index, 1,
                                                      UPPER(@Char))
                    END
                SET @Index = @Index + 1
            END
        RETURN @OutputString
    END
GO
