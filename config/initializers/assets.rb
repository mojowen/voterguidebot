
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w{guide.css avg.css avg.js
                                                 avg_embed.js avg_widget.js
                                                 emoji.css emoji.min.js}
