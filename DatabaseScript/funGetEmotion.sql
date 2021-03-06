/****** Object:  UserDefinedFunction [tallal78_8].[funGetEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP FUNCTION [tallal78_8].[funGetEmotion]
GO
/****** Object:  UserDefinedFunction [tallal78_8].[funGetEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [tallal78_8].[funGetEmotion]
    (
      @PremaLinkId BIGINT ,
      @UserID BIGINT
    )
RETURNS VARCHAR(MAX)
AS
    BEGIN
        DECLARE @Emoname VARCHAR(MAX) = ''
        SELECT  @Emoname = @Emoname + CAST(E.Id AS VARCHAR) + ',' + E.Name
                + ',' + CAST(( SELECT   COUNT(PEU.Id)
                               FROM     Premalink_Emotions_User PEU
                               WHERE    Premalink_Emotions_Id = PE.Id
                             ) AS VARCHAR)
                +',' + CAST(( SELECT ISNULL(ptu1.UserId, 0)
                         FROM   Premalink_Emotions_User ptu1
                         WHERE  ptu1.Premalink_Emotions_Id = pE.Id
                                AND ptu1.UserId = @UserID
                       ) AS VARCHAR) + '|'
        FROM    Emotions E
                INNER JOIN Premalink_Emotions PE ON E.Id = PE.EmotionId
                INNER JOIN Premalink_Emotions_User PEU ON PE.Id = PEU.Premalink_Emotions_Id
        WHERE   PE.PremalinkId = @PremaLinkId
        RETURN @Emoname
    END
GO
