FROM kyrylo/ruby-1.9.3p551

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["app"]

