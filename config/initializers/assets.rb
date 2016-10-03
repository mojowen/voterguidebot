
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w{guide.css mail.css
                                                 avg.css avg.js
                                                 avg_embed.js avg_widget.js
                                                 avg_img.css
                                                 emoji.css emoji.min.js}
