{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PatternSynonyms #-}

-- |
-- Module:      GUI.Widget.Types
-- Copyright:   (c) 2017 KolodeznyDiver
-- License:     BSD3
-- Maintainer:  KolodeznyDiver <kolodeznydiver@gmail.com>
-- Stability:   experimental
-- Portability: portable
--
-- Типы, классы и шаблоны для создания виджетов.

module GUI.Widget.Types(
    -- * Типы и константы используемые во многих виджетах.
    pattern MinInsideSpaceX, pattern MinInsideSpaceY, pattern KbdClickSpecPoint
    ,WidgetMouseState(..),FormItemWidgetDef(..),SortMode(..)
    -- * Обёртки для полиморфных функций.
    ,NoArgAction(..),OneArgAction(..),OneArgPredicate(..)
    -- * Распрстранённые для виджетов динамические \"проперти\".
    ,Clickable(..),DoubleClickable(..),Changeable(..)
    ,TextProperty(..),TextColorProperty(..),MinMaxValueProperty(..),ValueProperty(..),IxProperty(..)
    ,RowNumProperty(..),ColNumProperty(..)
    ,MouseStateProperty(..),OnEnd(..),Verifiable(..),Moveable(..),MarkersPropertyType,MarkersProperty(..)
                        ) where

import Control.Monad.IO.Class
import qualified Data.Text as T
import qualified Data.Vector.Unboxed as VU
import Data.Default
import SDL.Vect
import GUI.BaseLayer.Depend0.Types

pattern MinInsideSpaceX :: Coord -- Минимальные расстояния между элементами внутри оснвных виджетов
pattern MinInsideSpaceX = 5
pattern MinInsideSpaceY :: Coord -- Минимальные расстояния между элементами внутри оснвных виджетов
pattern MinInsideSpaceY = 3

pattern KbdClickSpecPoint :: GuiPoint
pattern KbdClickSpecPoint = P (V2 (-1) (-1))

-- | Состояние мыши для виджетов отслеживающих мышь и анимирующих себя в зависимости от её положения.
data WidgetMouseState =
          WidgetMouseOut -- ^ Мышь не над виджетом.
        | WidgetMouseIn -- ^ Мышь над виджетом.
        | WidgetMousePressed -- ^ Мышь над виджетом и её кнопка нажата.
                 deriving (Eq, Show)

-- | Общие настройки для всех виджетов для форм, в настоящий момент только margin's.
newtype FormItemWidgetDef = FormItemWidgetDef { formItemMargin    :: Maybe WidgetMargin
                                              }
                                              deriving (Show)

instance Default FormItemWidgetDef where
    def = FormItemWidgetDef Nothing

-- | Режим сортировки
data SortMode = Ascending | Descending
                 deriving (Eq, Show)

-- | Некое действие без параметров. Реакция на какое то событие.
newtype NoArgAction = NoArgAction {noArgAction :: forall m. MonadIO m => m ()}

-- | Некое действие с одним параметров. Реакция на изменение чего то.
newtype OneArgAction a = OneArgAction {oneArgAction :: forall m. MonadIO m => a -> m ()}

-- | Некий предикат с одним параметров.
newtype OneArgPredicate a = OneArgPredicate {oneArgPredicate :: forall m. MonadIO m => a -> m Bool}

-- | Для экземпляров этого класса типов можно назначить действие на щелчёк.
class Clickable a where
    onClick :: MonadIO m => a -> (forall n. MonadIO n => n ()) -> m ()

-- | Для экземпляров этого класса типов можно назначить действие на двойной щелчёк.
class DoubleClickable a where
    onDoubleClick :: MonadIO m => a -> (forall n. MonadIO n => n ()) -> m ()

-- | Для экземпляров этого класса типов можно назначить действие вызываемое виджетом при изменении
-- ассоциированного с ним значения.
class Changeable a b | a -> b where
    onChanged :: MonadIO m => a -> (forall n. MonadIO n => b -> n ()) -> m ()

-- | Для экземпляров этого класса типов можно назначить установку и извлечение некоего текста.
class TextProperty a where
    setText :: MonadIO m => a -> T.Text -> m ()
    getText :: MonadIO m => a -> m T.Text

-- | Для экземпляров этого класса типов можно назначить установку и извлечение некоего цвета.
class TextColorProperty a where
    setTextColor :: MonadIO m => a -> GuiColor -> m ()
    getTextColor :: MonadIO m => a -> m GuiColor

-- | Для экземпляров этого класса типов можно назначить установку и извлечение некоего диапазона значений.
class MinMaxValueProperty a b | a -> b where
    setMinValue :: MonadIO m => a -> b -> m ()
    getMinValue :: MonadIO m => a -> m b
    setMaxValue :: MonadIO m => a -> b -> m ()
    getMaxValue :: MonadIO m => a -> m b

-- | Для экземпляров этого класса типов можно назначить установку и извлечение некоего значения.
class ValueProperty a b | a -> b where
    setValue :: MonadIO m => a -> b -> m ()
    getValue :: MonadIO m => a -> m b

-- | Для экземпляров этого класса типов можно назначить установку и извлечение номера индекса.
class IxProperty a where
    setIx :: MonadIO m => a -> Int -> m ()
    getIx :: MonadIO m => a -> m Int

-- | Для экземпляров этого класса типов можно назначить установку и извлечение номера некоего ряда.
class RowNumProperty a where
    setRowNum :: MonadIO m => a -> Int -> m ()
    getRowNum :: MonadIO m => a -> m Int

-- | Для экземпляров этого класса типов можно назначить установку и извлечение номера некой колонки.
class ColNumProperty a where
    setColNum :: MonadIO m => a -> Int -> m ()
    getColNum :: MonadIO m => a -> m Int

-- | Для экземпляров этого класса типов можно назначить извлечение состояние мыши.
class MouseStateProperty a where
    getMouseState :: MonadIO m => a -> m WidgetMouseState

class OnEnd a b | a -> b where
    onEnd :: MonadIO m => a -> (forall n. MonadIO n => b -> n ()) -> m ()

class Verifiable a b | a -> b where
    setVerifier :: MonadIO m => a -> (forall n. MonadIO n => b -> n Bool) -> m ()

class Moveable a b | a -> b where
    onMove :: MonadIO m => a -> (forall n. MonadIO n => b -> n ()) -> m ()

type MarkersPropertyType = VU.Vector Bool

-- | Для экземпляров этого класса типов можно назначить установку и извлечение
-- @VU.Vectoor Bool@ - означающего какие элементы виджета маркированы.
class MarkersProperty a where
    setMarkers :: MonadIO m => a -> MarkersPropertyType -> m ()
    getMarkers :: MonadIO m => a -> m MarkersPropertyType
