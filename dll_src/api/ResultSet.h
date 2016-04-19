#ifndef SRC_RESULTSET_H_
#define SRC_RESULTSET_H_

#include <vector>
#include <map>

class ResultSet
{
protected:
	std::vector<std::string> columns;
	std::vector<std::vector<std::string*>*> rows;
	int position								= -1;
	int size();
public:
	virtual bool next();
	virtual bool previous();
	virtual bool isFirst();
	virtual bool isLast();
	virtual bool isBeforeFirst();
	virtual bool isAfterLast();
	virtual void first();
	virtual void last();
	virtual std::string getString(unsigned int column);
	virtual int getNumber(std::string column);
};

#endif