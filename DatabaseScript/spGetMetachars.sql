/****** Object:  StoredProcedure [tallal78_8].[spGetMetachars]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetMetachars]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetMetachars]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetMetachars] @WebsiteType INT
AS
    BEGIN
        SELECT  [Metachars]
        FROM    [WebsiteType]
        WHERE   id = @WebsiteType
    END

GO
