/****** Object:  StoredProcedure [tallal78_8].[spGetEmotionByWebsite]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetEmotionByWebsite]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetEmotionByWebsite]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [tallal78_8].[spGetEmotionByWebsite] @WebsiteId BIGINT
AS
    SELECT  PE.EmotionId AS EmotionId ,
            ( SELECT    Name
              FROM      Emotions
              WHERE     Id = PE.EmotionId
            ) AS EmotionName ,
            COUNT(PE.EmotionId) AS TotalCount
    FROM    Premalink_Emotions_User PEU
            INNER JOIN Premalink_Emotions PE ON PEU.Premalink_Emotions_Id = PE.Id
            INNER JOIN Premalink P ON P.Id = PE.PremalinkId
            INNER JOIN Website w ON w.id = P.Website_Id
    WHERE   w.Id = @WebsiteId
    GROUP BY PE.EmotionId

GO
