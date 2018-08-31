/****** Object:  StoredProcedure [tallal78_8].[spSearchWebsite]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spSearchWebsite]
GO
/****** Object:  StoredProcedure [tallal78_8].[spSearchWebsite]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spSearchWebsite]
    @PrefixText VARCHAR(MAX)
AS
    BEGIN
        DECLARE @str VARCHAR(MAX)

        SET @str = '%' + @PrefixText + '%'

        SELECT  Id ,
                Name
        FROM    Website
        WHERE   Name LIKE @str

    END
GO
