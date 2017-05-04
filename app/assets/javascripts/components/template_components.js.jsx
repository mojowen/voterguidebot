var ColorBlob = React.createClass({
  getDefaultProps: function() {
    return { color: 'transparent' }
  },
  render: function() {
    var style = {
      backgroundColor: this.props.color,
      border: '10px rgba(255, 255, 255, 0.5) solid',
      width: '100%',
      height: '200px',
      color: 'white',
      padding: '10px'
    }
    return <div style={style}>
      <h2 style={{ color: 'white', margin: 0, padding: 0 }}>THE BACK PAGE</h2>
      <p style={{ color: 'white' }}>This is what the back page of your guide will look like.</p>
    </div>
  }
})

var ColorText = React.createClass({
  getDefaultProps: function() {
    return { color: 'transparent' }
  },
  render: function() {
    return <div style={{ width: '200px' }}>
      <div className="name" style={{ textAlign: 'right', width: '60%', display: 'inline-block' }}>
        <h3 style={{ color: this.props.color, padding: 0, margin: 0 }} >Candidate Name</h3>
        <span style={{ fontSize: '8px', fontStyle: 'italic', lineHeight: '8px'}}>
          Independent
        </span>
      </div>
      <div className="photo" style={{ verticalAlign: 'top', width: '40%', display: 'inline-block' }}>
        <div className="img unknown"></div>
      </div>
    </div>
  }
})

var ContestType = React.createClass({
  getDefaultProps: function() {
    return { partial: 'contest_large' }
  },
  render: function() {
    var copy = {
      contest_large: 'Four candididates and six questions on two pages per contest',
      contest_small: 'Three candididates and three questions on one pages per contest',
    }
    return <div className="contest--type">
      <div className={this.props.partial + ' thumbnail'} />
      <p>{ copy[this.props.partial] }</p>
    </div>
  }
})

var YouTubeVideo = React.createClass({
  getDefaultProps: function() {
    return { video: 'dQw4w9WgXcQ' }
  },
  render: function() {
    if( this.props.video === 'no_video' ) return null
    return <iframe
      width="240"
      src={"https://www.youtube.com/embed/" + this.props.video}
      frameBorder="0"></iframe>
  }
})

var LinkPreview = React.createClass({
  getDefaultProps: function() {
    return { path: 'your-url', domain: 'http://example.org' }
  },
  url: function() {
    return [this.props.domain, this.props.path].join('/')
  },
  render: function() {
    return <a href={this.url()}>{ this.url() }</a>
  }
})

var SelectImages = React.createClass({
  getDefaultProps: function() {
    return { img: 'feds' }
  },
  render: function() {
    var images = {
      feds: 'https://s3-us-west-2.amazonaws.com/voterguides/feds.jpg',
      hands: 'https://s3-us-west-2.amazonaws.com/voterguides/hands.jpg',
      dcorps:  'https://s3-us-west-2.amazonaws.com/voterguides/democracycorpsregistration.jpg'
    }
    return <img src={images[this.props.img]} style={{ width: '200px'}} />
  }
})

var FooterImage = React.createClass({
  getDefaultProps: function() {
    return { img: 'https://s3-us-west-2.amazonaws.com/voterguides/feds.jpg' }
  },
  render: function() {
    var style = {
      width: '100%',
      height: '120px',
      backgroundColor: 'transparent',
      backgroundPosition: 'center center',
      backgroundRepeat: 'no-repeat',
      backgroundSize: 'cover',
      backgroundImage: 'url('+this.props.img+')'
    }
    return <div style={style} ></div>
  }
})

var HeaderImage = React.createClass({
  getDefaultProps: function() {
    return { img: 'https://s3-us-west-2.amazonaws.com/voterguides/feds.jpg' }
  },
  render: function() {
    var style = {
      width: '100%',
      height: '120px',
      backgroundColor: 'transparent',
      backgroundPosition: 'center center',
      backgroundRepeat: 'no-repeat',
      backgroundSize: 'cover',
      backgroundImage: 'url('+this.props.img+')',
      opacity: 0.4
    },
    header_style = {
      position: 'absolute',
      bottom: '-20px',
      left: '4px',
      fontSize: '20px',
      color: 'white',
      textShadow: 'none',
      textAlign: 'left',
      textTransform: 'none',
    }

    return <div style={{ backgroundColor: '#1470be' }}>
      <div style={style} ></div>
      <h1 style={header_style}>
        Your Title Here
      </h1>
    </div>
  }
})
