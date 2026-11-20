package org.tasks.sync

import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertTrue
import org.junit.Assert.assertNotNull
import org.junit.Test
import org.mockito.kotlin.doReturn
import org.mockito.kotlin.mock
import org.tasks.data.dao.CaldavDao
import org.tasks.data.entity.CaldavAccount

class IndependentSyncTest {
    @Test
    fun independentSyncDoesNotConsultASubscriptionOrRequireATasksAccount() = runTest {
        val account = CaldavAccount(accountType = CaldavAccount.TYPE_CALDAV)
        val dao = mock<CaldavDao> {
            onBlocking { getAccounts() } doReturn listOf(account)
        }
        var result: SyncRunner.SyncPass? = null
        val runner = SyncRunner(
            scope = this,
            caldavDao = dao,
            subscriptionProvider = { error("Independent sync must not consult billing") },
            pass = { result = it },
        )
        runner.syncNow(SyncSource.USER_INITIATED)
        assertNotNull(result)
        assertTrue(result!!.hasPro)
        assertTrue(result!!.accounts(CaldavAccount.TYPE_CALDAV).contains(account))
    }
}
