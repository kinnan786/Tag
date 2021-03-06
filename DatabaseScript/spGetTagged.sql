/****** Object:  StoredProcedure [tallal78_8].[spGetTagged]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetTagged]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetTagged]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetTagged] @TagId BIGINT
AS
    BEGIN
        
        SELECT  ( SELECT    Name
                  FROM      Tag
                  WHERE     id = t.TaggedoneId
                ) AS TagName ,
                TaggedoneId ,
                ( SUM(UpVote) - SUM(DownVote) ) AS TotalVote
        FROM    Tagged t
                INNER JOIN Tagged_Tag_User ON Tagged_Tag_User.TaggedId = t.Id
        WHERE   t.TagId = @TagId
        GROUP BY TaggedoneId
    END
GO
