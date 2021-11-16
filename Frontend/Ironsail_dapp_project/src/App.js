import logo from './ironsail_logo.png';
import './App.css';
import React, { Component } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';


function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
        Welcome to the world of Iron Sail, 
        where we ride the new winds with an iron will
        </p>
        
        <a
          className="App-link"
          href="https://ironsail.io/"
          target="_blank"
          rel="noopener noreferrer"
        >
          Get Info now
        </a>
      </header>
      <div className="body">
            <span className="helper" />
            <div className= "info_token">
              <div className="header">
                  <h2>IRONSAIL TOKEN PRIVATE SALE</h2>
                </div>
              <div className="row tokeninfo-row">
                
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Token name:</h3>    
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">IRONSAIL</h3>    
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Token Type:</h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">ERC20</h3>   
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Total sale: </h3>   
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info"><div className="popup_info" id="available_token">2500</div></h3>   
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Available:</h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3> <div className="popup_info" id="available_token">var_available</div></h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Price:</h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info"><div className="popup_info" id="price_token">var_price</div></h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info">Token payment:</h3>
                </div>
                <div className="col-md-3 col-sm-12 popup-content">
                  <h3 className="popup_info"> Tether (USDT)</h3>
                </div>
                
              </div>
              <div className="tokeninfo-button">
                  <button type="button" className="btn tokeninfo-btn section-btn smoothScroll trigger_popup_fricc" name="submit" style={{backgroundColor: 'green', color : "white"}}>Buy Token</button>
              </div>
            </div>
          </div>

     
    </div>
    //showTokenInfo();
  );
}

export default App;


