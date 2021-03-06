/****** Object:  StoredProcedure [tallal78_8].[spGetAllWebSite]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetAllWebSite]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetAllWebSite]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spGetAllWebSite]
    @PageNumber BIGINT ,
    @RowsPerPage BIGINT ,
    @SearchText VARCHAR(MAX) = ''
AS
    BEGIN
        IF @SearchText <> ''
            BEGIN

                DECLARE @str VARCHAR(MAX) = ''
                SET @str = '%' + @SearchText + '%'

                SELECT  [Id] ,
                        ISNULL([Name], '') AS Name ,
                        ISNULL([Image], '') AS [Image]
                FROM    [Website]
                WHERE   Name LIKE @str
                ORDER BY Id DESC
                        OFFSET ( @PageNumber - 1 ) * @RowsPerPage ROWS
		FETCH NEXT @RowsPerPage ROWS ONLY
    
            END
        ELSE
            BEGIN

                SELECT  [Id] ,
                        ISNULL([Name], '') AS Name ,
                        ISNULL([Image], '') AS [Image]
                FROM    [Website]
                ORDER BY Id DESC
                        OFFSET ( @PageNumber - 1 ) * @RowsPerPage ROWS
		FETCH NEXT @RowsPerPage ROWS ONLY
            
            END
    END
GO
