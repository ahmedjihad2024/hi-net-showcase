

import '../network/api.dart';

abstract class DataSourceAbs{
}

class DataSource implements DataSourceAbs{

  AppServices appServices;
  DataSource(this.appServices);

}

