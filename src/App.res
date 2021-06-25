%%raw(`import './App.css';`)
%%private(@module("./logo.svg") external logo: string = "default")

@react.component
let make = () => {
  <div className="App">
    <header className="App-header">
      <img src={logo} className="App-logo" alt="logo" />
      <p>
        {"Edit "->React.string}
        <code> {"src/App.js"->React.string} </code>
        {" and save to reload."->React.string}
      </p>
      <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">
        {"Learn React with ReScript!"->React.string}
        <p>
          {"With luck, App.res is actually migrated now. For the most part, anyway."->React.string}
        </p>
        <p> {"And now the logo is ported, too"->React.string} </p>
      </a>
    </header>
  </div>
}
