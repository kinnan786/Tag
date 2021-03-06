/****** Object:  StoredProcedure [tallal78_8].[spGetTagByUser]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetTagByUser]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetTagByUser]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spGetTagByUser] @UserID BIGINT
AS
    SELECT   Tag_Id ,
            ( SELECT    RTRIM(LTRIM(Name)) 
              FROM      Tag
              WHERE     id = Tag_Id
            ) AS NAME,
            COUNT(tag_Id) AS [COUNT]
    FROM    PremalinkTag_User ptu
            INNER JOIN PremalinkTags pt ON ptu.PremalinkTagId = pt.Id
	WHERE   ptu.UserId = @UserID
			GROUP BY Tag_Id

    
GO
