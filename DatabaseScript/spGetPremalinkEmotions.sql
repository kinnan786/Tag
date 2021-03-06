/****** Object:  StoredProcedure [tallal78_8].[spGetPremalinkEmotions]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetPremalinkEmotions]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetPremalinkEmotions]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetPremalinkEmotions]
    @Premalink VARCHAR(MAX) ,
    @UserID BIGINT = 0
AS
    BEGIN

        SELECT  PE.[Id] ,
                PE.[PremalinkId] ,
                PE.[EmotionId] ,
                ( SELECT    E.Name
                  FROM      Emotions E
                  WHERE     E.Id = PE.EmotionId
                ) AS EmotionName ,
                ( SELECT    COUNT(*)
                  FROM      Premalink_Emotions_User PEs
                  WHERE     PEs.Premalink_Emotions_Id = PE.Id
                ) AS TotalCount ,
                ISNULL(( SELECT ISNULL(PEU.Premalink_Emotions_Id, 0)
                         FROM   [Premalink_Emotions_User] PEU
                         WHERE  PEU.Premalink_Emotions_Id = PE.Id
                                AND PEU.UserId = @UserID
                       ), 0) AS UserEmotion
        FROM    Premalink_Emotions PE
                INNER JOIN Premalink_Emotions_User PEU ON PEU.Premalink_Emotions_Id = PE.Id
        WHERE   PE.PremalinkId = ( SELECT   Id
                                   FROM     Premalink
                                   WHERE    Link = @Premalink
                                 )
                AND ( SELECT    COUNT(PEU.Id)
                      FROM      Premalink_Emotions_User PEU
                      WHERE     Premalink_Emotions_Id = PE.Id
                    ) <> 0
        GROUP BY PE.[Id] ,
                PE.[PremalinkId] ,
                PE.[EmotionId] 



    END
GO
