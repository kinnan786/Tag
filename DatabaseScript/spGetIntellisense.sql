
ALTER PROCEDURE [spGetIntellisense]
    @searchtext VARCHAR(50) = ''
AS
    BEGIN
        DECLARE @Query VARCHAR(50) = '%' + @searchtext + '%';

        WITH    CTE_Tags
                  AS ( SELECT TOP 10
                                Id ,
                                Name ,
                                'Tag' AS Category
                       FROM     tallal78_8.Tag
                       WHERE    Name LIKE @Query
                     ),
                CTE_Emotion
                  AS ( SELECT TOP 10
                                Id ,
                                Name ,
                                'Website' AS Category
                       FROM     tallal78_8.Website
                       WHERE    Name LIKE @Query
                     )
            SELECT  Id ,
                    ISNULL(Name, '') AS Name ,
                    Category
            FROM    CTE_Emotion
            UNION
            SELECT  Id ,
                    ISNULL(Name, '') ,
                    Category
            FROM    CTE_Tags
 

    END