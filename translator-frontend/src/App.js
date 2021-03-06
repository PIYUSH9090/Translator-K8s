import React, {Component} from 'react';
import './App.css';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import TextField from 'material-ui/TextField';
import RaisedButton from 'material-ui/RaisedButton';
import Paper from 'material-ui/Paper';
import Polarity from "./components/Polarity";

const style = {
    marginLeft: 12,
};

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            sentence: '',
            spanishTranslation: '',
            polarity: undefined
        };
    };

    analyzeSentence() {
        console.log("Contacting 35.224.53.27:80");
        fetch('http://35.224.53.27:80/sentiment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({sentence: this.textField.getValue()})
        })
            .then(response => response.json())
            .then(data => this.setState(data));
    }

    translateSentence() {
        console.log("Contacting 35.224.53.27:80");
        fetch('http://35.224.53.27:80/translate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({sentence: this.textField.getValue()})
        })
            .then(response => response.json())
            .then(data => this.setState(data));
    }

    onEnterPress = e => {
        if (e.key === 'Enter') {
        this.analyzeSentence();
        }
    };

    render() {
        const polarityComponent = this.state.polarity !== undefined ?
            <Polarity sentence={this.state.sentence} polarity={this.state.polarity} spanishTranslation ={this.state.spanishTranslation}/> :
            null;
        
        //if (caches) {
          // Service worker cache should be cleared with caches.delete()
          //caches.keys().then(function(names) {
          //  for (let name of names) caches.delete(name);
          //});
        // delete browser cache and hard reload
        //window.location.reload(true);
        // TODO: note browser behaviours are still not standardized.
        // Browsers ignore all cache invalidate settings, for the sake of 
        // performance. 
        // https://dev.to/flexdinesh/cache-busting-a-react-app-22lk
       //}
 
        return (
            <MuiThemeProvider>
                <div className="centerize">
                    <Paper zDepth={1} className="content">
                        <h2>Translator</h2>
                        <TextField id="yourSentenceId" ref={ref => this.textField = ref} onKeyUp={this.onEnterPress.bind(this)}
                                   hintText="Type your sentence."/>
                        <RaisedButton id="yourSentenceSendId" label="Analyze" style={style} onClick={this.analyzeSentence.bind(this)}/>
                        <RaisedButton id="yourSentenceTranslateId" label="Translate" style={style} onClick={this.translateSentence.bind(this)}/>
                        {polarityComponent}
                    </Paper>
                </div>
            </MuiThemeProvider>
        );
    }
}

export default App;
