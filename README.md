# Remember
The journaling app I've always wanted

![CleanShot 2025-03-04 at 13 21 48@2x](https://github.com/user-attachments/assets/51cb996c-9d7f-4a26-9c3b-0671b7546f03)

Bouta be lit
Stay zen

## Development

### Setup

* `yarn install`
* `bundle install`
* `rails db:create`
* `rails db:setup`

### Environment Variables

You will need to create a `.env_overrides.rb` file and set the following environment variables:

Google Oauth Integration:
```ruby
ENV['GOOGLE_CLIENT_ID'] ||= 'development_client_id_here'
ENV['GOOGLE_CLIENT_SECRET'] ||= 'development_client_secret_here'
```

Rails encryption:
```ruby
ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY'] ||= ''
ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY'] ||= ''
ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT'] ||= ''
```

### Running the app

`bin/dev`

### Documentation

```mermaid
---
title: If you made Entry be the main thing and not connect days to users.
---
classDiagram
  class User {
    +String email
    +String name
    +String profile_image_url
  }

  class Event {
    +String name
    +DateTime start_date
    +DateTime end_date
    +String color
    +String decorator
  }

  class BeRealConnection {
    +String bereal_access_token
    +String firebase_id_token
    +String firebase_refresh_token
    +Boolean is_new_user
    +String name
    +String session_info
    +Integer status
    +String token_type
    +String uid
  }

  class Year {
    +Date year
    methods for beginning and end
  }

  class Quarter {
    +Date quarter
    methods for beginning and end
  }

  class Month {
    +Date month
    methods for beginning and end
  }

  class Day {
    +Date date
    methods for beginning and end
  }

  class BeRealMemory {
    +String be_real_id
    +Boolean late
    +JSON location
  }

  class Badge {
    +String color
    +String icon_name
    +String name
  }

  class EntryBadge {

  }

  class Entry {
    +String journalable_type(day, month, quarter, year)
    +String title
    +RichContent content
    +Image thing
    +TSVector tsv
  }

  namespace ActiveStorage {
    class VariantRecord {
      +String variant_digest
    }

    class Blob {
      +Integer byte_size
      +String checksum
      +String content_type
      +String filename
      +String key
      +Text metadata
      +String service_name
    }

    class Attachment {
      +String name
      +String record_type
    }
  }

  namespace ActionText {
    class RichText {
      +Text body
      +String name
      +String record_type
    }

    class EncryptedRichText {
      +Text body
      +String name
      +String record_type
    }
  }

  User -- BeRealConnection

  User --> Badge : has_many
  User --> Entry : has_many
  User --> Event : has_many

  Year --> Quarter : has_many
  Quarter --> Month : has_many
  Month --> Day : has_many

  Year --> Entry : has_many
  Quarter --> Entry : has_many
  Month --> Entry : has_many
  Day --> Entry : has_many

  Badge --> EntryBadge : has_many
  Entry --> EntryBadge : has_many

  Entry -- BeRealMemory

  VariantRecord --> Attachment : has_many
  VariantRecord -- EncryptedRichText
  VariantRecord --> RichText : has_many
  Blob --> Attachment : has_many
  Blob <--> RichText : has_many
  RichText --> RichText : has_many

  Entry --> Attachment : has_many
  Entry --> RichText : has_many
  Entry -- EncryptedRichText : has_many

  BeRealMemory --> Attachment : has_many
  BeRealMemory --> RichText : has_many
  BeRealMemory -- EncryptedRichText : has_many

```
