module SimpleService.HTTP.Server where

import SimpleService.Config (Config(..))
import SimpleService.DB.Connect (PoolConnection)
import SimpleService.Error.Handler (handleException)
import SimpleService.HTTP.Middleware.Logging (logRequest, logResponse)
import SimpleService.HTTP.Routing (setup)
import SimpleService.System.Log (infoM)
import Web.Scotty (defaultHandler, middleware, scotty)

start :: Config -> PoolConnection -> IO ()
start config pool = do
  let port :: Int = cfgPort config
  infoM "HTTP.Server" $ "Starting service with port " ++ show port
  scotty port $ do
    defaultHandler handleException
    middleware logRequest
    setup config pool
    middleware logResponse
