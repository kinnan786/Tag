/****** Object:  StoredProcedure [tallal78_8].[spGetTaggedEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetTaggedEmotion]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetTaggedEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetTaggedEmotion]
    @TagId BIGINT ,
    @LoggedInUser BIGINT = 0
AS
    BEGIN

        DECLARE @index BIGINT = 0
        DECLARE @count BIGINT = 0
        
        DECLARE @ReturnTable TABLE
            (
              EmotionID BIGINT ,
              EmotionName VARCHAR(50) ,
              LoggedUserEmotion BIGINT ,
              TotalCount BIGINT
            );

        DECLARE @TempTable TABLE
            (
              RowNumber BIGINT ,
              EmotionID BIGINT ,
              EmotionName VARCHAR(50) ,
              TotalCount BIGINT
            );
        
        WITH    MyCTE
                  AS ( SELECT   TE.EmotionId ,
                                ( SELECT    Name
                                  FROM      Emotions
                                  WHERE     id = TE.EmotionId
                                ) AS EmotionName ,
                                COUNT(TE.EmotionId) AS TotalCount
                       FROM     Tag_Emotion_User TEU
                                LEFT JOIN TaggedEmotion TE ON TEU.TaggedEmotionId = TE.Id
                       WHERE    TagId = @TagId
                       GROUP BY TE.EmotionId
					   HAVING  COUNT(TE.EmotionId) <> 0
                     )
            INSERT  INTO @TempTable
                    ( RowNumber ,
                      EmotionId ,
                      EmotionName ,
                      TotalCount			
                    )
                    SELECT  ROW_NUMBER() OVER ( ORDER BY C.TotalCount DESC ) AS RowNumber ,
                            C.EmotionId ,
                            C.EmotionName ,
                            C.TotalCount
                    FROM    MyCTE C
                            LEFT JOIN EmotionUser E ON E.EmotionId = C.EmotionId
		
        SELECT  @count = COUNT(ISNULL(EmotionId, 0))
        FROM    @TempTable

        DECLARE @EmotionID BIGINT = 0 
        DECLARE @EmotionName VARCHAR(MAX)
        DECLARE @LoggedUserEmotion BIGINT = 0 
        DECLARE @TotalCount BIGINT = 0 
				
        WHILE @index < @count
            BEGIN

                SET @index += 1;

                SELECT  @EmotionID = EmotionID
                FROM    @TempTable
                WHERE   RowNumber = @index 

                SELECT  @EmotionName = EmotionName
                FROM    @TempTable
                WHERE   RowNumber = @index 
       
                IF EXISTS ( SELECT  *
                            FROM    Tag_Emotion_User
                            WHERE   TaggedEmotionId = ( SELECT
                                                              Id
                                                        FROM  TaggedEmotion
                                                        WHERE TagId = @TagId
                                                              AND EmotionId = @EmotionID
                                                              AND UserId = @LoggedInUser
                                                      ) )
                    SET @LoggedUserEmotion = 1
                ELSE
                    SET @LoggedUserEmotion = 0
		
                SELECT  @TotalCount = TotalCount
                FROM    @TempTable
                WHERE   RowNumber = @index 

                IF NOT EXISTS ( SELECT  *
                                FROM    @ReturnTable
                                WHERE   EmotionID = ( SELECT  EmotionID
                                                      FROM    @TempTable
                                                      WHERE   RowNumber = @index
                                                    ) )
                    BEGIN
                        INSERT  @ReturnTable
                                ( EmotionId ,
                                  EmotionName ,
                                  LoggedUserEmotion ,
                                  TotalCount
							
                                )
                        VALUES  ( @EmotionID ,
                                  @EmotionName ,
                                  @LoggedUserEmotion ,
                                  @TotalCount						
                                )
                    END
            END

        SELECT  C.EmotionID ,
                C.EmotionName ,
                C.LoggedUserEmotion ,
                C.TotalCount
        FROM    @ReturnTable C

    END

GO
