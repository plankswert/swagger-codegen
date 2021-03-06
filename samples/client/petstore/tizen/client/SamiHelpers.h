#ifndef HELPERS_H_
#define HELPERS_H_

#include <FApp.h>
#include <FBase.h>
#include <FSystem.h>
#include <FWebJson.h>
#include <FLocales.h>
#include "SamiHelpers.h"
#include "SamiObject.h"

using Tizen::Base::String;
using Tizen::Base::DateTime;
using namespace Tizen::Web::Json;
using namespace Tizen::Base::Collection;

using Tizen::Base::Long;
using Tizen::Base::DateTime;
using Tizen::Base::String;
using Tizen::Base::Integer;

namespace Swagger {
JsonObject*
toJson(void* v, String type, String containerType);

void
jsonToValue(void* target, IJsonValue* ptr, String type, String innerType);

Integer*
jsonToInteger(IJsonValue* value);

Long*
jsonToLong(IJsonValue* value);

String*
jsonToString(IJsonValue* value);

DateTime*
jsonToDateTime(IJsonValue* value);

String
stringify(void* ptr, String type);

} /* namespace Swagger */
#endif /* HELPERS_H_ */
